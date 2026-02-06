import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/simulation_service.dart';
import '../models/vehicle_config.dart';
import '../models/simulation_result.dart';
import '../notifiers/vehicle_notifier.dart';

import '../widgets/config_tabs/chassis_tab.dart';
import '../widgets/config_tabs/aero_tab.dart';
import '../widgets/config_tabs/powertrain_tab.dart';
import '../widgets/config_tabs/tires_tab.dart';
import '../widgets/config_tabs/kinematics_tab.dart';

import '../tabs/analysis_tab.dart';
import '../tabs/track_map_tab.dart';
import '../tabs/scores_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isSimulating = false;
  SimulationResult? _simulationResult;

  void _runSimulation() async {
    setState(() => _isSimulating = true);

    try {
      final config = Provider.of<VehicleNotifier>(context, listen: false).config;
      final service = Provider.of<SimulationService>(context, listen: false);

      final result = await service.runSimulation(config);

      setState(() {
        _simulationResult = result;
        _selectedIndex = 5; // Auto-switch to Analysis tab on success
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSimulating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brown Formula Racing - Lap Time Simulator'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton.icon(
              onPressed: _isSimulating ? null : _runSimulation,
              icon: _isSimulating 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                  : const Icon(Icons.play_arrow),
              label: Text(_isSimulating ? "Running..." : "RUN SIMULATION"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: const Color(0xFF1E1E2C),
            selectedIconTheme: const IconThemeData(color: Colors.blueAccent),
            unselectedIconTheme: const IconThemeData(color: Colors.white54),
            selectedLabelTextStyle: const TextStyle(color: Colors.blueAccent),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
            // NOTE: This list uses 'const' which is fine because these icons/text ARE constant
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.directions_car), label: Text('Chassis')),
              NavigationRailDestination(icon: Icon(Icons.air), label: Text('Aero')),
              NavigationRailDestination(icon: Icon(Icons.bolt), label: Text('Power')),
              NavigationRailDestination(icon: Icon(Icons.donut_large), label: Text('Tires')),
              NavigationRailDestination(icon: Icon(Icons.pivot_table_chart), label: Text('Kinematics')),
              NavigationRailDestination(icon: Icon(Icons.analytics), label: Text('Analysis')),
              NavigationRailDestination(icon: Icon(Icons.map), label: Text('Track Map')),
              NavigationRailDestination(icon: Icon(Icons.emoji_events),label: Text('Scores'),),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // We use Expanded to fill the rest of the screen
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  // We use a switch statement here instead of a list. 
  // This avoids the "Not a constant expression" error because we are not
  // trying to put dynamic data (result) into a const list.
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0: return const ChassisTab();
      case 1: return const AeroTab();
      case 2: return const PowertrainTab();
      case 3: return const TireTab(); 
      case 4: return const KinematicsTab();
      case 5: return AnalysisTab(result: _simulationResult); 
      case 6: return TrackMapTab(result: _simulationResult);
      case 7: return ScoresTab(result: _simulationResult);
      default: return const SizedBox();
    }
  }
}