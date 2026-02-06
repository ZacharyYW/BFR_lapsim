import 'package:json_annotation/json_annotation.dart';

part 'simulation_result.g.dart';

@JsonSerializable()
class SimulationResult {
  final List<double> timeTrace;
  final List<double> velocityTrace;
  final List<double> latAccelTrace;
  final List<double> longAccelTrace;

  // NEW PHASE 4 FIELDS
  final List<double> xTraceEndurance;
  final List<double> yTraceEndurance;
  final List<double> xTraceAutocross;
  final List<double> yTraceAutocross;

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

  factory SimulationResult.fromJson(Map<String, dynamic> json) => _$SimulationResultFromJson(json);
  Map<String, dynamic> toJson() => _$SimulationResultToJson(this);
}