import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VelocityChart extends StatelessWidget {
  final List<double> time;
  final List<double> velocity;

  const VelocityChart({
    super.key,
    required this.time,
    required this.velocity,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _getLineSpots(),
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.1)),
              ),
            ],
            titlesData: _buildDefaultTitles("Time (s)", "Speed (ft/s)"),
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.white12)),
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }

  List<FlSpot> _getLineSpots() {
    List<FlSpot> spots = [];
    final count = min(time.length, velocity.length);
    for (int i = 0; i < count; i++) {
      spots.add(FlSpot(time[i], velocity[i]));
    }
    return spots;
  }

  FlTitlesData _buildDefaultTitles(String bottomLabel, String leftLabel) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: Text(leftLabel, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: _leftTitleWidgets),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: Text(bottomLabel, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 10, getTitlesWidget: _bottomTitleWidgets),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return Text(value.toStringAsFixed(1), style: const TextStyle(color: Colors.white38, fontSize: 10));
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(value.toInt().toString(), style: const TextStyle(color: Colors.white38, fontSize: 10)),
    );
  }
}