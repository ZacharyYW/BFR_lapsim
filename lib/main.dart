import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/vehicle_config.dart';
import 'services/simulation_service.dart';
// We'll create this screen next
import 'screens/dashboard_screen.dart'; 

void main() {
  // Dependency Injection:
  // Check the OS and give the app the correct "Engine"
  SimulationService service;
  
  if (Platform.isWindows) {
    // On Windows, use the real thing (eventually)
    // For now, use Mock until Phase 3 is ready
    service = MockSimulationService(); 
  } else {
    // On Mac, always use Mock
    service = MockSimulationService();
  }

  runApp(
    MultiProvider(
      providers: [
        // 1. Provide the Service logic
        Provider<SimulationService>.value(value: service),
        
        // 2. Provide the Data State (The active Vehicle Configuration)
        // This lets any widget read/edit the car settings
       ChangeNotifierProvider<VehicleNotifier>(
          create: (_) => VehicleNotifier(
            VehicleConfig(
              chassis: ChassisConfig(),
              aero: AeroConfig(),
              powertrain: PowertrainConfig(
                  engineRpm: [1000, 14000],
                  engineTorque: [40, 50],
                  gearRatios: [3.2, 1.1]
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
      title: 'BFR LapSim',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}