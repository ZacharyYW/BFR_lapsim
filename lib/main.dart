import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Use package imports to avoid type conflicts
import 'package:laptime_simulator/models/vehicle_config.dart';
import 'package:laptime_simulator/services/simulation_service.dart';
import 'package:laptime_simulator/screens/dashboard_screen.dart';
import 'package:laptime_simulator/notifiers/vehicle_notifier.dart';

void main() {
  final service = SimulationService();

  runApp(
    MultiProvider(
      providers: [
        Provider<SimulationService>.value(value: service),
        ChangeNotifierProvider<VehicleNotifier>(
          create: (_) => VehicleNotifier(
            VehicleConfig(
              chassis: const ChassisConfig(),
              aero: const AeroConfig(),
              powertrain: const PowertrainConfig(
                // FIX: Use .0 to ensure these are doubles, not ints
                engineRpm: [6200.0, 14100.0],
                engineTorque: [40.0, 53.0],
                gearRatios: [3.2, 2.5, 1.8, 1.4, 1.1],
              ),
              tires: const TireConfig(),
              kinematics: const KinematicsConfig(),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brown Formula Racing',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}