import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_config.g.dart';

// -----------------------------------------------------------------------------
// 2. THE DATA MODELS (IMMUTABLE)
// -----------------------------------------------------------------------------

@JsonSerializable(explicitToJson: true)
class VehicleConfig {
  final TireConfig tires;         // Section 1
  final PowertrainConfig powertrain; // Section 2
  final ChassisConfig chassis;    // Section 3 (Architecture)
  final KinematicsConfig kinematics; // Section 4
  final AeroConfig aero;          // Section 5

  const VehicleConfig({
    required this.tires,
    required this.powertrain,
    required this.chassis,
    required this.kinematics,
    required this.aero,
  });

  // CopyWith for deep updates
  VehicleConfig copyWith({
    TireConfig? tires,
    PowertrainConfig? powertrain,
    ChassisConfig? chassis,
    KinematicsConfig? kinematics,
    AeroConfig? aero,
  }) {
    return VehicleConfig(
      tires: tires ?? this.tires,
      powertrain: powertrain ?? this.powertrain,
      chassis: chassis ?? this.chassis,
      kinematics: kinematics ?? this.kinematics,
      aero: aero ?? this.aero,
    );
  }

  factory VehicleConfig.fromJson(Map<String, dynamic> json) => _$VehicleConfigFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleConfigToJson(this);
}

// --- SECTION 1: TIRE MODEL ---
@JsonSerializable()
class TireConfig {
  final double tireRadius;      // 'tire_radius' (ft)
  final double scalingFactorX;  // 'sf_x'
  final double scalingFactorY;  // 'sf_y'

  const TireConfig({
    this.tireRadius = 0.754, // 9.05/12
    this.scalingFactorX = 0.6,
    this.scalingFactorY = 0.47,
  });

  TireConfig copyWith({
    double? tireRadius,
    double? scalingFactorX,
    double? scalingFactorY,
  }) {
    return TireConfig(
      tireRadius: tireRadius ?? this.tireRadius,
      scalingFactorX: scalingFactorX ?? this.scalingFactorX,
      scalingFactorY: scalingFactorY ?? this.scalingFactorY,
    );
  }

  factory TireConfig.fromJson(Map<String, dynamic> json) => _$TireConfigFromJson(json);
  Map<String, dynamic> toJson() => _$TireConfigToJson(this);
}

// --- SECTION 2: POWERTRAIN MODEL ---
@JsonSerializable()
class PowertrainConfig {
  final List<double> engineRpm;        // 'engineSpeed'
  final List<double> engineTorque;     // 'engineTq'
  final double primaryReduction;       // 'primaryReduction'
  final List<double> gearRatios;       // 'gear'
  final double finalDrive;             // 'finalDrive'
  final double shiftPoint;             // 'shiftpoint'
  final double drivetrainEfficiency;   // 'drivetrainLosses'
  final double shiftTime;              // 'shift_time'
  final double diffLockingTorque;      // 'T_lock'

  const PowertrainConfig({
    required this.engineRpm,
    required this.engineTorque,
    required this.gearRatios,
    this.primaryReduction = 2.11, // 76/36
    this.finalDrive = 3.33,       // 40/12
    this.shiftPoint = 14000.0,
    this.drivetrainEfficiency = 0.85,
    this.shiftTime = 0.25,
    this.diffLockingTorque = 90.0,
  });

  PowertrainConfig copyWith({
    List<double>? engineRpm,
    List<double>? engineTorque,
    double? primaryReduction,
    List<double>? gearRatios,
    double? finalDrive,
    double? shiftPoint,
    double? drivetrainEfficiency,
    double? shiftTime,
    double? diffLockingTorque,
  }) {
    return PowertrainConfig(
      engineRpm: engineRpm ?? this.engineRpm,
      engineTorque: engineTorque ?? this.engineTorque,
      primaryReduction: primaryReduction ?? this.primaryReduction,
      gearRatios: gearRatios ?? this.gearRatios,
      finalDrive: finalDrive ?? this.finalDrive,
      shiftPoint: shiftPoint ?? this.shiftPoint,
      drivetrainEfficiency: drivetrainEfficiency ?? this.drivetrainEfficiency,
      shiftTime: shiftTime ?? this.shiftTime,
      diffLockingTorque: diffLockingTorque ?? this.diffLockingTorque,
    );
  }

  factory PowertrainConfig.fromJson(Map<String, dynamic> json) => _$PowertrainConfigFromJson(json);
  Map<String, dynamic> toJson() => _$PowertrainConfigToJson(this);
}

// --- SECTION 3: CHASSIS / ARCHITECTURE ---
@JsonSerializable()
class ChassisConfig {
  final double lltd;             // 'LLTD'
  final double totalWeight;      // 'W'
  final double weightDistFront;  // 'WDF'
  final double cgHeight;         // 'cg'
  final double wheelbase;        // 'l'
  final double trackWidthFront;  // 'twf'
  final double trackWidthRear;   // 'twr'

  const ChassisConfig({
    this.lltd = 51.5,
    this.totalWeight = 660.0,
    this.weightDistFront = 50.0,
    this.cgHeight = 1.1,         // 13.2/12
    this.wheelbase = 5.04,       // 60.5/12
    this.trackWidthFront = 3.83, // 46/12
    this.trackWidthRear = 3.66,  // 44/12
  });

  ChassisConfig copyWith({
    double? lltd,
    double? totalWeight,
    double? weightDistFront,
    double? cgHeight,
    double? wheelbase,
    double? trackWidthFront,
    double? trackWidthRear,
  }) {
    return ChassisConfig(
      lltd: lltd ?? this.lltd,
      totalWeight: totalWeight ?? this.totalWeight,
      weightDistFront: weightDistFront ?? this.weightDistFront,
      cgHeight: cgHeight ?? this.cgHeight,
      wheelbase: wheelbase ?? this.wheelbase,
      trackWidthFront: trackWidthFront ?? this.trackWidthFront,
      trackWidthRear: trackWidthRear ?? this.trackWidthRear,
    );
  }

  factory ChassisConfig.fromJson(Map<String, dynamic> json) => _$ChassisConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ChassisConfigToJson(this);
}

// --- SECTION 4: SUSPENSION KINEMATICS ---
@JsonSerializable()
class KinematicsConfig {
  final double rollGradientFront;  // 'rg_f'
  final double rollGradientRear;   // 'rg_r'
  final double pitchGradient;      // 'pg'
  final double rideRateFront;      // 'WRF'
  final double rideRateRear;       // 'WRR'
  final double staticCamberFront;  // 'IA_staticf'
  final double staticCamberRear;   // 'IA_staticr'
  final double camberGainFront;    // 'IA_compensationf'
  final double camberGainRear;     // 'IA_compensationr'
  final double casterFront;        // 'casterf'
  final double casterRear;         // 'casterr'
  final double kpiFront;           // 'KPIf'
  final double kpiRear;            // 'KPIr'

  const KinematicsConfig({
    this.rollGradientFront = 0.0,
    this.rollGradientRear = 0.0,
    this.pitchGradient = 0.0,
    this.rideRateFront = 180.0,
    this.rideRateRear = 180.0,
    this.staticCamberFront = 0.0,
    this.staticCamberRear = 0.0,
    this.camberGainFront = 10.0,
    this.camberGainRear = 20.0,
    this.casterFront = 0.0,
    this.casterRear = 4.1568,
    this.kpiFront = 0.0,
    this.kpiRear = 0.0,
  });

  KinematicsConfig copyWith({
    double? rollGradientFront,
    double? rollGradientRear,
    double? pitchGradient,
    double? rideRateFront,
    double? rideRateRear,
    double? staticCamberFront,
    double? staticCamberRear,
    double? camberGainFront,
    double? camberGainRear,
    double? casterFront,
    double? casterRear,
    double? kpiFront,
    double? kpiRear,
  }) {
    return KinematicsConfig(
      rollGradientFront: rollGradientFront ?? this.rollGradientFront,
      rollGradientRear: rollGradientRear ?? this.rollGradientRear,
      pitchGradient: pitchGradient ?? this.pitchGradient,
      rideRateFront: rideRateFront ?? this.rideRateFront,
      rideRateRear: rideRateRear ?? this.rideRateRear,
      staticCamberFront: staticCamberFront ?? this.staticCamberFront,
      staticCamberRear: staticCamberRear ?? this.staticCamberRear,
      camberGainFront: camberGainFront ?? this.camberGainFront,
      camberGainRear: camberGainRear ?? this.camberGainRear,
      casterFront: casterFront ?? this.casterFront,
      casterRear: casterRear ?? this.casterRear,
      kpiFront: kpiFront ?? this.kpiFront,
      kpiRear: kpiRear ?? this.kpiRear,
    );
  }

  factory KinematicsConfig.fromJson(Map<String, dynamic> json) => _$KinematicsConfigFromJson(json);
  Map<String, dynamic> toJson() => _$KinematicsConfigToJson(this);
}

// --- SECTION 5: AERO PARAMETERS ---
@JsonSerializable()
class AeroConfig {
  final double clArea;          // 'Cl'
  final double cdArea;          // 'Cd'
  final double centerOfPressure; // 'CoP'

  const AeroConfig({
    this.clArea = 0.0418,
    this.cdArea = 0.0184,
    this.centerOfPressure = 48.0,
  });

  AeroConfig copyWith({
    double? clArea,
    double? cdArea,
    double? centerOfPressure,
  }) {
    return AeroConfig(
      clArea: clArea ?? this.clArea,
      cdArea: cdArea ?? this.cdArea,
      centerOfPressure: centerOfPressure ?? this.centerOfPressure,
    );
  }

  factory AeroConfig.fromJson(Map<String, dynamic> json) => _$AeroConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AeroConfigToJson(this);
}