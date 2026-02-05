import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/vehicle_config.dart';
import 'services/simulation_service.dart';
import 'screens/dashboard_screen.dart'; 
import 'notifiers/vehicle_notifier.dart'; // <--- Now importing correctly

void main() {
  final service = SimulationService();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<SimulationService>.value(value: service),
        ChangeNotifierProvider<VehicleNotifier>(
          create: (_) => VehicleNotifier(
            VehicleConfig(
              chassis: ChassisConfig(),
              aero: AeroConfig(),
              powertrain: PowertrainConfig(
                  engineRpm: [6200, 14100], 
                  engineTorque: [40, 53],
                  gearRatios: [3.2, 2.5, 1.8, 1.4, 1.1]
              ),
              tires: TireConfig(),
              kinematics: KinematicsConfig(),
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
      title: 'Optimum Mindstorm',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}