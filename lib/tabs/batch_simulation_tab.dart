import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle_config.dart';
import '../models/simulation_result.dart';
import '../services/simulation_service.dart';
import '../notifiers/vehicle_notifier.dart';
import 'dart:math';

class BatchSimulationTab extends StatefulWidget {
  const BatchSimulationTab({super.key});

  @override
  State<BatchSimulationTab> createState() => _BatchSimulationTabState();
}

class _BatchSimulationTabState extends State<BatchSimulationTab> {
  // Setup State
  String _selectedParam = 'Total Weight (lbs)';
  final TextEditingController _startCtrl = TextEditingController(text: '600');
  final TextEditingController _endCtrl = TextEditingController(text: '700');
  final TextEditingController _stepsCtrl = TextEditingController(text: '5');
  
  // Execution State
  bool _isRunning = false;
  double _progress = 0.0;
  List<SimulationResult>? _results;
  List<double>? _inputValues;

  // Parameters we can sweep
  final Map<String, Function(VehicleConfig, double)> _paramMap = {
    'Total Weight (lbs)': (c, v) => c.copyWith(chassis: c.chassis.copyWith(totalWeight: v)),
    'Weight Dist Front (%)': (c, v) => c.copyWith(chassis: c.chassis.copyWith(weightDistFront: v)),
    'CG Height (ft)': (c, v) => c.copyWith(chassis: c.chassis.copyWith(cgHeight: v)),
    'Aero Cl (Area)': (c, v) => c.copyWith(aero: c.aero.copyWith(clArea: v)),
    'Aero Cd (Area)': (c, v) => c.copyWith(aero: c.aero.copyWith(cdArea: v)),
    'Aero CoP (%)': (c, v) => c.copyWith(aero: c.aero.copyWith(centerOfPressure: v)),
    'Final Drive Ratio': (c, v) => c.copyWith(powertrain: c.powertrain.copyWith(finalDrive: v)),
  };

  void _runBatch() async {
    setState(() {
      _isRunning = true;
      _progress = 0.0;
      _results = null;
    });

    try {
      final start = double.parse(_startCtrl.text);
      final end = double.parse(_endCtrl.text);
      final steps = int.parse(_stepsCtrl.text);
      
      if (steps < 2) throw Exception("Steps must be at least 2");

      final baseConfig = Provider.of<VehicleNotifier>(context, listen: false).config;
      final service = Provider.of<SimulationService>(context, listen: false);

      // 1. Generate Configs
      List<VehicleConfig> batchConfigs = [];
      List<double> values = [];
      final stepSize = (end - start) / (steps - 1);

      for (int i = 0; i < steps; i++) {
        double val = start + (stepSize * i);
        // Clean float precision issues
        val = double.parse(val.toStringAsFixed(4)); 
        values.add(val);
        
        final modifier = _paramMap[_selectedParam]!;
        batchConfigs.add(modifier(baseConfig, val));
      }

      _inputValues = values;

      // 2. Run Batch
      final results = await service.runBatch(batchConfigs, (prog) {
        setState(() => _progress = prog);
      });

      setState(() {
        _results = results;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isRunning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT PANEL: Controls
          SizedBox(
            width: 300,
            child: Card(
              color: Colors.white10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Sweep Configuration", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    
                    // Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedParam,
                      dropdownColor: Colors.grey[800],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: "Parameter", labelStyle: TextStyle(color: Colors.white54)),
                      items: _paramMap.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                      onChanged: (val) => setState(() => _selectedParam = val!),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildInput(_startCtrl, "Start")),
                        const SizedBox(width: 10),
                        Expanded(child: _buildInput(_endCtrl, "End")),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInput(_stepsCtrl, "Steps (Count)"),
                    
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isRunning ? null : _runBatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(_isRunning ? "Simulating..." : "Run Sweep"),
                      ),
                    ),
                    
                    if (_isRunning)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: LinearProgressIndicator(value: _progress),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 24),

          // RIGHT PANEL: Results
          Expanded(
            child: _results == null 
              ? const Center(child: Text("Configure and run a sweep to see results.", style: TextStyle(color: Colors.white24)))
              : _buildResultsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      ),
    );
  }

  Widget _buildResultsView() {
    // Determine bounds for chart
    final points = _results!.map((r) => r.totalPoints).toList();
    final minY = points.reduce(min);
    final maxY = points.reduce(max);
    final buffer = (maxY - minY) * 0.1;

    List<FlSpot> spots = [];
    for(int i=0; i<_results!.length; i++) {
      spots.add(FlSpot(_inputValues![i], _results![i].totalPoints));
    }

    return Column(
      children: [
        // 1. Chart
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 4,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: true, color: Colors.greenAccent.withOpacity(0.1)),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(_selectedParam, style: const TextStyle(color: Colors.white54)),
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (val, meta) => Text(val.toStringAsFixed(1), style: const TextStyle(color: Colors.white30, fontSize: 10))),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text("Total Points", style: TextStyle(color: Colors.white54)),
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: const TextStyle(color: Colors.white30, fontSize: 10))),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true, drawVerticalLine: true),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.white10)),
                minY: minY - buffer,
                maxY: maxY + buffer,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),

        // 2. Data Table
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.white12),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Colors.white24),
                  children: const [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Value", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Endurance (s)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Autocross (s)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Total Points", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ],
                ),
                ...List.generate(_results!.length, (index) {
                  final res = _results![index];
                  final val = _inputValues![index];
                  return TableRow(
                    children: [
                      Padding(padding: const EdgeInsets.all(8.0), child: Text(val.toString(), style: const TextStyle(color: Colors.white70))),
                      Padding(padding: const EdgeInsets.all(8.0), child: Text(res.timeTrace.last.toStringAsFixed(3), style: const TextStyle(color: Colors.white70))),
                      Padding(padding: const EdgeInsets.all(8.0), child: Text(res.timeTraceAx.last.toStringAsFixed(3), style: const TextStyle(color: Colors.white70))),
                      Padding(padding: const EdgeInsets.all(8.0), child: Text(res.totalPoints.toStringAsFixed(1), style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}