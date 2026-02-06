import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GForceChart extends StatelessWidget {
  final List<double> time;
  final List<double> latAccel;
  final List<double> longAccel;

  const GForceChart({
    super.key,
    required this.time,
    required this.latAccel,
    required this.longAccel,
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
              // Lat G
              LineChartBarData(
                spots: _getLineSpots(latAccel),
                isCurved: false,
                color: Colors.orangeAccent,
                barWidth: 2,
                dotData: const FlDotData(show: false),
              ),
              // Long G
              LineChartBarData(
                spots: _getLineSpots(longAccel),
                isCurved: false,
                color: Colors.greenAccent,
                barWidth: 2,
                dotData: const FlDotData(show: false),
              ),
            ],
            titlesData: _buildDefaultTitles("Time (s)", "Acceleration (G)"),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (val) => FlLine(color: val == 0 ? Colors.white30 : Colors.white10, strokeWidth: val == 0 ? 1 : 1),
            ),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.white12)),
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }

  List<FlSpot> _getLineSpots(List<double> data) {
    List<FlSpot> spots = [];
    final count = min(time.length, data.length);
    for (int i = 0; i < count; i++) {
      spots.add(FlSpot(time[i], data[i]));
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