import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GGVDiagram extends StatelessWidget {
  final List<double> latAccel;
  final List<double> longAccel;

  const GGVDiagram({
    super.key,
    required this.latAccel,
    required this.longAccel,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: _getGGVSpots(),
            minX: -2.5, maxX: 2.5,
            minY: -2.5, maxY: 2.5,
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (_) => const FlLine(color: Colors.white10, strokeWidth: 1),
              getDrawingVerticalLine: (_) => const FlLine(color: Colors.white10, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: _leftTitleWidgets)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: _bottomTitleWidgets)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.white12)),
          ),
        ),
      ),
    );
  }

  List<ScatterSpot> _getGGVSpots() {
    List<ScatterSpot> spots = [];
    final count = min(latAccel.length, longAccel.length);
    for (int i = 0; i < count; i++) {
      spots.add(ScatterSpot(
        latAccel[i],
        longAccel[i],
        dotPainter: FlDotCirclePainter(
          radius: 2,
          color: _getColorForG(longAccel[i], latAccel[i]),
          strokeWidth: 0,
        ),
      ));
    }
    return spots;
  }

  Color _getColorForG(double longG, double latG) {
    if (longG < -0.5) return Colors.redAccent.withOpacity(0.6);
    if (longG > 0.5) return Colors.greenAccent.withOpacity(0.6);
    if (latG.abs() > 0.5) return Colors.blueAccent.withOpacity(0.6);
    return Colors.grey.withOpacity(0.3);
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