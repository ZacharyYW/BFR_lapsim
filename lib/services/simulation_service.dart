import 'dart:async';
import 'dart:math';
import '../models/vehicle_config.dart';
import '../models/simulation_result.dart';

// 1. The Contract (Interface)
// The UI only ever talks to this. It doesn't care if it's Mac or Windows.
abstract class SimulationService {
  Future<SimulationResult> runSimulation(VehicleConfig config);
}

// 2. The Mock Implementation (For Mac Development)
// This generates fake sine waves so you can test your charts.
class MockSimulationService implements SimulationService {
  @override
  Future<SimulationResult> runSimulation(VehicleConfig config) async {
    // Fake a 2-second "calculation" delay
    await Future.delayed(Duration(seconds: 2));

    // Generate fake telemetry data
    List<double> time = [];
    List<double> vel = [];
    List<double> lat = [];
    List<double> long = [];

    // Create a 60-second lap with data every 0.1s
    for (var i = 0; i < 600; i++) {
      double t = i * 0.1;
      time.add(t);
      
      // Fake Physics: Velocity is a sine wave affected by the user's "Final Drive"
      // This proves the UI is actually passing data to the service!
      double maxSpeed = 100.0 / config.powertrain.finalDrive; 
      vel.add(maxSpeed * 0.8 * (sin(t / 5).abs())); 

      lat.add(1.5 * sin(t / 3));
      long.add(0.5 * cos(t / 3));
    }

    return SimulationResult(
      timeTrace: time,
      velocityTrace: vel,
      latAccelTrace: lat,
      longAccelTrace: long,
      enduranceScore: 250.0 + Random().nextInt(50), // Random score between 250-300
      autocrossScore: 118.5,
      skidpadScore: 71.5,
      accelerationScore: 95.5,
      totalPoints: 535.5,
    );
  }
}

// 3. The Windows Implementation (Placeholder)
// We will fill this in later during Phase 3
class WindowsSimulationService implements SimulationService {
  @override
  Future<SimulationResult> runSimulation(VehicleConfig config) async {
    // TODO: Implement file I/O and Process.run here
    throw UnimplementedError("Windows implementation not ready yet");
  }
}