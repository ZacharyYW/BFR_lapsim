import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/vehicle_config.dart';
import '../models/simulation_result.dart';

class SimulationService {
  static const String _executableName = 'Lap_Sim_CLI.exe';
  
  // --- SINGLE RUN (Existing) ---
  Future<SimulationResult> runSimulation(VehicleConfig config) async {
    if (!Platform.isWindows) {
      // Simulates a delay for non-Windows (Testing)
      await Future.delayed(const Duration(milliseconds: 500));
      final jsonString = await rootBundle.loadString('assets/data/test_output.json');
      final outputJson = jsonDecode(jsonString);
      return SimulationResult.fromJson(outputJson);
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final inputPath = p.join(tempDir.path, 'input.json');
      final outputPath = p.join(tempDir.path, 'output.json');

      final projectRoot = Directory.current.path; 
      final exePath = p.join(projectRoot, 'backend', _executableName);

      if (!await File(exePath).exists()) {
        throw Exception("Backend engine not found at: $exePath");
      }

      final jsonString = jsonEncode(config.toJson());
      await File(inputPath).writeAsString(jsonString);

      final result = await Process.run(exePath, [inputPath, outputPath], runInShell: true);

      if (result.exitCode != 0) {
        throw Exception("Simulation Engine Failed (Exit Code ${result.exitCode}).\n${result.stderr}");
      }

      final outputFile = File(outputPath);
      if (!await outputFile.exists()) {
        throw Exception("Output file was not generated.");
      }

      final outputString = await outputFile.readAsString();
      final Map<String, dynamic> outputJson = jsonDecode(outputString);

      return SimulationResult.fromJson(outputJson);

    } catch (e) {
      print("Simulation Error: $e");
      rethrow;
    }
  }

  // --- NEW: BATCH RUN ---
  Future<List<SimulationResult>> runBatch(
    List<VehicleConfig> configs, 
    Function(double progress) onProgress
  ) async {
    List<SimulationResult> results = [];
    
    for (int i = 0; i < configs.length; i++) {
      // Run the simulation
      try {
        final result = await runSimulation(configs[i]);
        results.add(result);
      } catch (e) {
        // If one fails, we stop or continue? Let's throw for now to alert the user.
        throw Exception("Batch failed at step ${i + 1}: $e");
      }
      
      onProgress((i + 1) / configs.length);
    }
    
    return results;
  }
}