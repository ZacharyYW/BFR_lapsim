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
                engineRpm: [6200, 6300, 6400, 6500, 6600, 6700, 6800, 6900, 7000, 7100, 7200, 7300, 7400,
                  7500, 7600, 7700, 7800, 7900, 8000, 8100, 8200, 8300, 8400, 8500, 8600, 8700,
                  8800, 8900, 9000, 9100, 9200, 9300, 9400, 9500, 9600, 9700, 9800, 9900, 10000,
                  10100, 10200, 10300, 10400, 10500, 10600, 10700, 10800, 10900, 11000, 11100,
                  11200, 11300, 11400, 11500, 11600, 11700, 11800, 11900, 12000, 12100, 12200,
                  12300, 12400, 12500, 12600, 12700, 12800, 12900, 13000, 13100, 13200, 13300,
                  13400, 13500, 13600, 13700, 13800, 13900, 14000, 14100],
                engineTorque: [41.57, 42.98, 44.43, 45.65, 46.44, 47.09, 47.52, 48.58, 49.57, 50.41, 51.43,
                    51.48, 51.0, 49.311, 48.94, 48.66, 49.62, 49.60, 47.89, 47.91, 48.09, 48.57,
                    49.07, 49.31, 49.58, 49.56, 49.84, 50.10, 50.00, 50.00, 50.75, 51.25, 52.01,
                    52.44, 52.59, 52.73, 53.34, 53.72, 52.11, 52.25, 51.66, 50.5, 50.34, 50.50,
                    50.50, 50.55, 50.63, 50.17, 50.80, 49.73, 49.35, 49.11, 48.65, 48.28, 48.28,
                    47.99, 47.68, 47.43, 47.07, 46.67, 45.49, 45.37, 44.67, 43.8, 43.0, 42.3,
                    42.00, 41.96, 41.70, 40.43, 39.83, 38.60, 38.46, 37.56, 36.34, 35.35, 33.75,
                    33.54, 32.63, 31.63
              ],
                gearRatios: [2.75, 2.0, 1.67, 1.44, 1.30, 1.21],
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