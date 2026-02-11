import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VelocityChart extends StatefulWidget {
  final List<double> time;
  final List<double> velocity;

  const VelocityChart({
    super.key,
    required this.time,
    required this.velocity,
  });

  @override
  State<VelocityChart> createState() => _VelocityChartState();
}

class _VelocityChartState extends State<VelocityChart> {
  // Zoom State
  double _minX = 0;
  double _maxX = 100;
  
  // Cache original bounds
  double _origMinX = 0;
  double _origMaxX = 100;

  @override
  void initState() {
    super.initState();
    _resetBounds();
  }

  @override
  void didUpdateWidget(VelocityChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.time != widget.time) {
      _resetBounds();
    }
  }

  void _resetBounds() {
    if (widget.time.isNotEmpty) {
      _origMinX = widget.time.first;
      _origMaxX = widget.time.last;
      _minX = _origMinX;
      _maxX = _origMaxX;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we have no data
    if (widget.time.isEmpty) return const SizedBox();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: GestureDetector(
          onDoubleTap: () => setState(() => _resetBounds()), // Reset on double tap
          onHorizontalDragUpdate: (details) {
            // Pan
            double range = _maxX - _minX;
            double sensitivity = range / context.size!.width;
            double delta = -details.primaryDelta! * sensitivity;
            
            setState(() {
              if (_minX + delta >= _origMinX && _maxX + delta <= _origMaxX) {
                _minX += delta;
                _maxX += delta;
              }
            });
          },
          onScaleUpdate: (details) {
            // Zoom (Pinch)
            if (details.horizontalScale == 1.0) return;
            
            double center = (_minX + _maxX) / 2;
            double currentRange = _maxX - _minX;
            double newRange = currentRange / details.horizontalScale;
            
            // Limit zoom depth
            if (newRange < 1.0) newRange = 1.0; 
            if (newRange > (_origMaxX - _origMinX)) newRange = _origMaxX - _origMinX;

            setState(() {
              _minX = center - newRange / 2;
              _maxX = center + newRange / 2;
              
              // Clamp to bounds
              if (_minX < _origMinX) {
                 _minX = _origMinX;
                 _maxX = _minX + newRange;
              }
              if (_maxX > _origMaxX) {
                _maxX = _origMaxX;
                _minX = _maxX - newRange;
              }
            });
          },
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
              minX: _minX,
              maxX: _maxX,
              titlesData: _buildDefaultTitles("Time (s)", "Speed (ft/s)"),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.white12)),
              clipData: const FlClipData.all(), // CLIP IS IMPORTANT FOR ZOOM
            ),
            duration: Duration.zero,
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getLineSpots() {
    List<FlSpot> spots = [];
    final count = min(widget.time.length, widget.velocity.length);
    for (int i = 0; i < count; i++) {
      spots.add(FlSpot(widget.time[i], widget.velocity[i]));
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
        sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: _bottomTitleWidgets),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return Text(value.toStringAsFixed(0), style: const TextStyle(color: Colors.white38, fontSize: 10));
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    // Only show titles if they fit the current zoom level
    if (value < _minX || value > _maxX) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(value.toInt().toString(), style: const TextStyle(color: Colors.white38, fontSize: 10)),
    );
  }
}