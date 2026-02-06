import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/simulation_result.dart';

class AnalysisTab extends StatelessWidget {
  final SimulationResult? result;

  const AnalysisTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Center(
        child: Text("Run a simulation to view analysis data.",
            style: TextStyle(color: Colors.white54)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Friction Circle (GGV)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          _buildGGVChart(result!),
          const SizedBox(height: 30),
          const Text("Telemetry Traces",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          _buildVelocityChart(result!),
          const SizedBox(height: 20),
          _buildGForceChart(result!),
        ],
      ),
    );
  }

  // --- WIDGET: FRICTION CIRCLE (GGV) ---
  Widget _buildGGVChart(SimulationResult data) {
    final spots = <ScatterSpot>[];
    for (int i = 0; i < data.latAccelTrace.length; i += 5) {
      spots.add(ScatterSpot(
        data.latAccelTrace[i], 
        data.longAccelTrace[i],
        // UPDATED FOR NEW FL_CHART API
        dotPainter: FlDotCirclePainter(
          radius: 2,
          color: _getColorForG(data.latAccelTrace[i], data.longAccelTrace[i]),
          strokeWidth: 0,
        ),
      ));
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: spots,
          minX: -2.5, maxX: 2.5,
          minY: -2.5, maxY: 2.5,
          gridData: FlGridData(show: true, drawVerticalLine: true),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.white12)),
          titlesData: FlTitlesData(show: false),
        ),
      ),
    );
  }

  // --- WIDGET: VELOCITY TRACE ---
  Widget _buildVelocityChart(SimulationResult data) {
    final points = <FlSpot>[];
    for (int i = 0; i < data.timeTrace.length; i += 10) {
      points.add(FlSpot(data.timeTrace[i], data.velocityTrace[i]));
    }

    return _buildLineChartContainer("Velocity (ft/s)", points, Colors.blueAccent);
  }

  // --- WIDGET: G-FORCE TRACE (Lat vs Long) ---
  Widget _buildGForceChart(SimulationResult data) {
    final latPoints = <FlSpot>[];
    final longPoints = <FlSpot>[];
    
    for (int i = 0; i < data.timeTrace.length; i += 10) {
      latPoints.add(FlSpot(data.timeTrace[i], data.latAccelTrace[i]));
      longPoints.add(FlSpot(data.timeTrace[i], data.longAccelTrace[i]));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(spots: latPoints, color: Colors.cyan, dotData: FlDotData(show: false)),
            LineChartBarData(spots: longPoints, color: Colors.orange, dotData: FlDotData(show: false)),
          ],
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildLineChartContainer(String title, List<FlSpot> points, Color color) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: points,
                    color: color,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
                  ),
                ],
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForG(double lat, double long) {
    double magnitude = (lat * lat) + (long * long);
    if (magnitude > 2.0) return Colors.red;
    if (magnitude > 1.0) return Colors.yellow;
    return Colors.green;
  }
}