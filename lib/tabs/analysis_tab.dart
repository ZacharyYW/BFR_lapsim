import 'dart:math';
import 'package:flutter/material.dart';
import '../models/simulation_result.dart';
import '../widgets/charts/ggv_diagram.dart';
import '../widgets/charts/velocity_chart.dart';
import '../widgets/charts/gforce_chart.dart';

class AnalysisTab extends StatefulWidget {
  final SimulationResult? result;

  const AnalysisTab({super.key, required this.result});

  @override
  State<AnalysisTab> createState() => _AnalysisTabState();
}

class _AnalysisTabState extends State<AnalysisTab> {
  bool _showGForce = false;
  bool _showAutocross = false; 

  @override
  Widget build(BuildContext context) {
    if (widget.result == null) {
      return const Center(child: Text("Run simulation to view analysis.", style: TextStyle(color: Colors.white54)));
    }

    final res = widget.result!;
    
    // SWITCH DATA BASED ON TOGGLE
    final time = _showAutocross ? res.timeTraceAx : res.timeTrace;
    final velocity = _showAutocross ? res.velocityTraceAx : res.velocityTrace;
    final latAccel = _showAutocross ? res.latAccelTraceAx : res.latAccelTrace;
    final longAccel = _showAutocross ? res.longAccelTraceAx : res.longAccelTrace;

    // Recalculate stats for the selected track
    final maxSpeed = velocity.isNotEmpty ? velocity.reduce(max) : 0.0;
    final maxLatG = latAccel.isNotEmpty ? latAccel.reduce((a, b) => a.abs() > b.abs() ? a : b).abs() : 0.0;
    final maxLongG = longAccel.isNotEmpty ? longAccel.reduce((a, b) => a.abs() > b.abs() ? a : b) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER WITH TOGGLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Text("Analysis", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
               Row(
                children: [
                  const Text("Endurance", style: TextStyle(color: Colors.white70)),
                  Switch(
                    value: _showAutocross,
                    activeColor: Colors.orangeAccent,
                    onChanged: (val) => setState(() => _showAutocross = val),
                  ),
                  const Text("Autocross", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. SUMMARY CARDS
          Row(
            children: [
              _SummaryCard("Top Speed", "${maxSpeed.toStringAsFixed(1)} ft/s", Colors.blueAccent),
              const SizedBox(width: 12),
              _SummaryCard("Max Lat G", "${maxLatG.toStringAsFixed(2)} G", Colors.orangeAccent),
              const SizedBox(width: 12),
              _SummaryCard("Peak Brake", "${maxLongG.abs().toStringAsFixed(2)} G", Colors.redAccent),
            ],
          ),
          const SizedBox(height: 24),

          // 2. GGV DIAGRAM (Imported Widget)
          const Text("GGV Diagram", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GGVDiagram(latAccel: latAccel, longAccel: longAccel),

          const SizedBox(height: 24),

          // 3. TELEMETRY TRACES (Imported Widgets)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Telemetry", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _ChartToggle("Velocity", !_showGForce, () => setState(() => _showGForce = false)),
                  const SizedBox(width: 8),
                  _ChartToggle("G-Force", _showGForce, () => setState(() => _showGForce = true)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          
          _showGForce 
            ? GForceChart(time: time, latAccel: latAccel, longAccel: longAccel)
            : VelocityChart(time: time, velocity: velocity),
        ],
      ),
    );
  }

  // --- WIDGETS (Internal Helpers for Analysis Tab) ---

  Widget _SummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _ChartToggle(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.blueAccent : Colors.white24),
        ),
        child: Text(text, style: TextStyle(color: isActive ? Colors.white : Colors.white54, fontSize: 12)),
      ),
    );
  }
}