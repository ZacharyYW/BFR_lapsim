import 'package:flutter/material.dart';
import 'package:laptime_simulator/models/vehicle_config.dart'; // Standardized import

class VehicleNotifier extends ChangeNotifier {
  VehicleConfig _config;

  VehicleNotifier(this._config);

  VehicleConfig get config => _config;

  void updateConfig(VehicleConfig newConfig) {
    _config = newConfig;
    notifyListeners();
  }

  void updateChassis(ChassisConfig chassis) {
    _config = _config.copyWith(chassis: chassis);
    notifyListeners();
  }

  void updateAero(AeroConfig aero) {
    _config = _config.copyWith(aero: aero);
    notifyListeners();
  }
  
  void updatePowertrain(PowertrainConfig powertrain) {
    _config = _config.copyWith(powertrain: powertrain);
    notifyListeners();
  }

  void updateTires(TireConfig tires) {
    _config = _config.copyWith(tires: tires);
    notifyListeners();
  }

  void updateKinematics(KinematicsConfig kinematics) {
    _config = _config.copyWith(kinematics: kinematics);
    notifyListeners();
  }
}