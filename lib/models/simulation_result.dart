import 'package:json_annotation/json_annotation.dart';

part 'simulation_result.g.dart';

@JsonSerializable()
class SimulationResult {
  // --- Telemetry Traces ---
  final List<double> timeTrace;
  final List<double> velocityTrace;     // ft/s
  final List<double> latAccelTrace;     // G's
  final List<double> longAccelTrace;    // G's

  // --- NEW: Track Map Coordinates (Phase 4) ---
  // These match the fields we just added to Lap_Sim_CLI.m
  final List<double> xTraceEndurance;
  final List<double> yTraceEndurance;
  final List<double> xTraceAutocross;
  final List<double> yTraceAutocross;

  // --- Event Scorecard ---
  final double enduranceScore;
  final double autocrossScore;
  final double skidpadScore;
  final double accelerationScore;
  final double totalPoints;

  SimulationResult({
    required this.timeTrace,
    required this.velocityTrace,
    required this.latAccelTrace,
    required this.longAccelTrace,
    // Add the new required fields here
    required this.xTraceEndurance,
    required this.yTraceEndurance,
    required this.xTraceAutocross,
    required this.yTraceAutocross,
    
    required this.enduranceScore,
    required this.autocrossScore,
    required this.skidpadScore,
    required this.accelerationScore,
    required this.totalPoints,
  });

  // Connects to the generated code
  factory SimulationResult.fromJson(Map<String, dynamic> json) => _$SimulationResultFromJson(json);
  Map<String, dynamic> toJson() => _$SimulationResultToJson(this);
}