// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleConfig _$VehicleConfigFromJson(Map<String, dynamic> json) =>
    VehicleConfig(
      tires: TireConfig.fromJson(json['tires'] as Map<String, dynamic>),
      powertrain: PowertrainConfig.fromJson(
        json['powertrain'] as Map<String, dynamic>,
      ),
      chassis: ChassisConfig.fromJson(json['chassis'] as Map<String, dynamic>),
      kinematics: KinematicsConfig.fromJson(
        json['kinematics'] as Map<String, dynamic>,
      ),
      aero: AeroConfig.fromJson(json['aero'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VehicleConfigToJson(VehicleConfig instance) =>
    <String, dynamic>{
      'tires': instance.tires.toJson(),
      'powertrain': instance.powertrain.toJson(),
      'chassis': instance.chassis.toJson(),
      'kinematics': instance.kinematics.toJson(),
      'aero': instance.aero.toJson(),
    };

TireConfig _$TireConfigFromJson(Map<String, dynamic> json) => TireConfig(
  tireRadius: (json['tireRadius'] as num?)?.toDouble() ?? 0.754,
  scalingFactorX: (json['scalingFactorX'] as num?)?.toDouble() ?? 0.6,
  scalingFactorY: (json['scalingFactorY'] as num?)?.toDouble() ?? 0.47,
);

Map<String, dynamic> _$TireConfigToJson(TireConfig instance) =>
    <String, dynamic>{
      'tireRadius': instance.tireRadius,
      'scalingFactorX': instance.scalingFactorX,
      'scalingFactorY': instance.scalingFactorY,
    };

PowertrainConfig _$PowertrainConfigFromJson(Map<String, dynamic> json) =>
    PowertrainConfig(
      engineRpm:
          (json['engineRpm'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      engineTorque:
          (json['engineTorque'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      gearRatios:
          (json['gearRatios'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      primaryReduction: (json['primaryReduction'] as num?)?.toDouble() ?? 2.11,
      finalDrive: (json['finalDrive'] as num?)?.toDouble() ?? 3.33,
      shiftPoint: (json['shiftPoint'] as num?)?.toDouble() ?? 14000.0,
      drivetrainEfficiency:
          (json['drivetrainEfficiency'] as num?)?.toDouble() ?? 0.85,
      shiftTime: (json['shiftTime'] as num?)?.toDouble() ?? 0.25,
      diffLockingTorque:
          (json['diffLockingTorque'] as num?)?.toDouble() ?? 90.0,
    );

Map<String, dynamic> _$PowertrainConfigToJson(PowertrainConfig instance) =>
    <String, dynamic>{
      'engineRpm': instance.engineRpm,
      'engineTorque': instance.engineTorque,
      'primaryReduction': instance.primaryReduction,
      'gearRatios': instance.gearRatios,
      'finalDrive': instance.finalDrive,
      'shiftPoint': instance.shiftPoint,
      'drivetrainEfficiency': instance.drivetrainEfficiency,
      'shiftTime': instance.shiftTime,
      'diffLockingTorque': instance.diffLockingTorque,
    };

ChassisConfig _$ChassisConfigFromJson(Map<String, dynamic> json) =>
    ChassisConfig(
      lltd: (json['lltd'] as num?)?.toDouble() ?? 51.5,
      totalWeight: (json['totalWeight'] as num?)?.toDouble() ?? 660.0,
      weightDistFront: (json['weightDistFront'] as num?)?.toDouble() ?? 50.0,
      cgHeight: (json['cgHeight'] as num?)?.toDouble() ?? 1.1,
      wheelbase: (json['wheelbase'] as num?)?.toDouble() ?? 5.04,
      trackWidthFront: (json['trackWidthFront'] as num?)?.toDouble() ?? 3.83,
      trackWidthRear: (json['trackWidthRear'] as num?)?.toDouble() ?? 3.66,
    );

Map<String, dynamic> _$ChassisConfigToJson(ChassisConfig instance) =>
    <String, dynamic>{
      'lltd': instance.lltd,
      'totalWeight': instance.totalWeight,
      'weightDistFront': instance.weightDistFront,
      'cgHeight': instance.cgHeight,
      'wheelbase': instance.wheelbase,
      'trackWidthFront': instance.trackWidthFront,
      'trackWidthRear': instance.trackWidthRear,
    };

KinematicsConfig _$KinematicsConfigFromJson(Map<String, dynamic> json) =>
    KinematicsConfig(
      rollGradientFront: (json['rollGradientFront'] as num?)?.toDouble() ?? 0.0,
      rollGradientRear: (json['rollGradientRear'] as num?)?.toDouble() ?? 0.0,
      pitchGradient: (json['pitchGradient'] as num?)?.toDouble() ?? 0.0,
      rideRateFront: (json['rideRateFront'] as num?)?.toDouble() ?? 180.0,
      rideRateRear: (json['rideRateRear'] as num?)?.toDouble() ?? 180.0,
      staticCamberFront: (json['staticCamberFront'] as num?)?.toDouble() ?? 0.0,
      staticCamberRear: (json['staticCamberRear'] as num?)?.toDouble() ?? 0.0,
      camberGainFront: (json['camberGainFront'] as num?)?.toDouble() ?? 10.0,
      camberGainRear: (json['camberGainRear'] as num?)?.toDouble() ?? 20.0,
      casterFront: (json['casterFront'] as num?)?.toDouble() ?? 0.0,
      casterRear: (json['casterRear'] as num?)?.toDouble() ?? 4.1568,
      kpiFront: (json['kpiFront'] as num?)?.toDouble() ?? 0.0,
      kpiRear: (json['kpiRear'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$KinematicsConfigToJson(KinematicsConfig instance) =>
    <String, dynamic>{
      'rollGradientFront': instance.rollGradientFront,
      'rollGradientRear': instance.rollGradientRear,
      'pitchGradient': instance.pitchGradient,
      'rideRateFront': instance.rideRateFront,
      'rideRateRear': instance.rideRateRear,
      'staticCamberFront': instance.staticCamberFront,
      'staticCamberRear': instance.staticCamberRear,
      'camberGainFront': instance.camberGainFront,
      'camberGainRear': instance.camberGainRear,
      'casterFront': instance.casterFront,
      'casterRear': instance.casterRear,
      'kpiFront': instance.kpiFront,
      'kpiRear': instance.kpiRear,
    };

AeroConfig _$AeroConfigFromJson(Map<String, dynamic> json) => AeroConfig(
  clArea: (json['clArea'] as num?)?.toDouble() ?? 0.0418,
  cdArea: (json['cdArea'] as num?)?.toDouble() ?? 0.0184,
  centerOfPressure: (json['centerOfPressure'] as num?)?.toDouble() ?? 48.0,
);

Map<String, dynamic> _$AeroConfigToJson(AeroConfig instance) =>
    <String, dynamic>{
      'clArea': instance.clArea,
      'cdArea': instance.cdArea,
      'centerOfPressure': instance.centerOfPressure,
    };
