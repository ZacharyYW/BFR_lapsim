import 'package:json_annotation/json_annotation.dart';

part 'simulation_result.g.dart';

@JsonSerializable()
class SimulationResult {
  // Telemetry Traces (Time vs Value)
  // We use List<double> because JSON is simple. 
  // Index 0 is time 0.0s, Index 1 is time 0.1s, etc.
  final List<double> timeTrace;
  final List<double> velocityTrace;     // ft/s
  final List<double> latAccelTrace;     // G's
  final List<double> longAccelTrace;    // G's

  // Event Scorecard (Calculated in Section 17 of Lap_Sim.m)
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
    required this.enduranceScore,
    required this.autocrossScore,
    required this.skidpadScore,
    required this.accelerationScore,
    required this.totalPoints,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) => _$SimulationResultFromJson(json);
  Map<String, dynamic> toJson() => _$SimulationResultToJson(this);
}