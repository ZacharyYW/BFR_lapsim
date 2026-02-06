import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // Ensure fl_chart is in pubspec.yaml

import '../models/vehicle_config.dart';
import '../models/simulation_result.dart';
import '../services/simulation_service.dart';
import '../notifiers/vehicle_notifier.dart';

// Import the sub-components we will create next
import '../widgets/config_tabs/aero_tab.dart';
import '../widgets/config_tabs/chassis_tab.dart';
import '../widgets/config_tabs/powertrain_tab.dart';
import '../widgets/config_tabs/tires_tab.dart';
import '../widgets/config_tabs/kinematics_tab.dart';

import '../tabs/analysis_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SimulationResult? _result;
  bool _isLoading = false;

  Future<void> _runSimulation() async {
    setState(() => _isLoading = true);
    
    final notifier = Provider.of<VehicleNotifier>(context, listen: false);
    final config = notifier.config; 

    final service = Provider.of<SimulationService>(context, listen: false);

    try {
      final result = await service.runSimulation(config);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Simulation Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brown Formula Racing // Lap Sim"),
        actions: [
          if (_isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: CircularProgressIndicator(color: Colors.white),
            ))
          else
            FilledButton.icon(
              onPressed: _runSimulation,
              icon: const Icon(Icons.play_arrow),
              label: const Text("RUN SIMULATION"),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          const SizedBox(width: 20),
        ],
      ),
      body: Row(
        children: [
          // LEFT PANEL: Configuration
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    const TabBar(
                      isScrollable: true,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Chassis"),
                        Tab(text: "Aero"),
                        Tab(text: "Powertrain"),
                        Tab(text: "Tires"),
                        Tab(text: "Kinematics"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: const [
                          ChassisTab(),
                          AeroTab(),
                          PowertrainTab(),
                          TireTab(),
                          KinematicsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // RIGHT PANEL: Results
          Expanded(
            flex: 3,
            child: _result == null
                ? const Center(child: Text("Ready to Simulate"))
                : _ResultsPanel(result: _result!),
          ),
        ],
      ),
    );
  }
}

// --- Internal Widget for Results Visualization ---
class _ResultsPanel extends StatelessWidget {
  final SimulationResult result;

  const _ResultsPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // 1. Scorecards
        Row(
          children: [
            _ScoreCard(title: "Total Points", value: result.totalPoints, isMain: true),
            _ScoreCard(title: "Endurance", value: result.enduranceScore),
            _ScoreCard(title: "Autocross", value: result.autocrossScore),
          ],
        ),
        const SizedBox(height: 20),
        
        // 2. Telemetry Chart (Velocity)
        const Text("Velocity Trace", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (int i = 0; i < result.timeTrace.length; i += 5)
                      FlSpot(result.timeTrace[i], result.velocityTrace[i]),
                  ],
                  
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3, 
                  
                  dotData: const FlDotData(show: false), 
                  
                  belowBarData: BarAreaData(
                    show: true, 
                    color: Colors.blue.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final double value;
  final bool isMain;

  const _ScoreCard({required this.title, required this.value, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: isMain ? Colors.blue.shade50 : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 5),
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: isMain ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: isMain ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}