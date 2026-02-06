// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulationResult _$SimulationResultFromJson(Map<String, dynamic> json) =>
    SimulationResult(
      timeTrace:
          (json['timeTrace'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      velocityTrace:
          (json['velocityTrace'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      latAccelTrace:
          (json['latAccelTrace'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      longAccelTrace:
          (json['longAccelTrace'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      xTraceEndurance:
          (json['xTraceEndurance'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      yTraceEndurance:
          (json['yTraceEndurance'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      xTraceAutocross:
          (json['xTraceAutocross'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      yTraceAutocross:
          (json['yTraceAutocross'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      enduranceScore: (json['enduranceScore'] as num).toDouble(),
      autocrossScore: (json['autocrossScore'] as num).toDouble(),
      skidpadScore: (json['skidpadScore'] as num).toDouble(),
      accelerationScore: (json['accelerationScore'] as num).toDouble(),
      totalPoints: (json['totalPoints'] as num).toDouble(),
    );

Map<String, dynamic> _$SimulationResultToJson(SimulationResult instance) =>
    <String, dynamic>{
      'timeTrace': instance.timeTrace,
      'velocityTrace': instance.velocityTrace,
      'latAccelTrace': instance.latAccelTrace,
      'longAccelTrace': instance.longAccelTrace,
      'xTraceEndurance': instance.xTraceEndurance,
      'yTraceEndurance': instance.yTraceEndurance,
      'xTraceAutocross': instance.xTraceAutocross,
      'yTraceAutocross': instance.yTraceAutocross,
      'enduranceScore': instance.enduranceScore,
      'autocrossScore': instance.autocrossScore,
      'skidpadScore': instance.skidpadScore,
      'accelerationScore': instance.accelerationScore,
      'totalPoints': instance.totalPoints,
    };
