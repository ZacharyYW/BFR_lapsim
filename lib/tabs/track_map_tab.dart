import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/simulation_result.dart';

class TrackMapTab extends StatefulWidget {
  final SimulationResult? result;

  const TrackMapTab({super.key, required this.result});

  @override
  State<TrackMapTab> createState() => _TrackMapTabState();
}

class _TrackMapTabState extends State<TrackMapTab> {
  int _currentIndex = 0;
  bool _showAutocross = true; // Toggle state

  @override
  Widget build(BuildContext context) {
    if (widget.result == null) {
      return const Center(child: Text("Run simulation to view track map.", style: TextStyle(color: Colors.white54)));
    }

    final res = widget.result!;
    // Select data based on toggle
    final xTrace = _showAutocross ? res.xTraceAutocross : res.xTraceEndurance;
    final yTrace = _showAutocross ? res.yTraceAutocross : res.yTraceEndurance;
    final timeTrace = _showAutocross ? res.timeTraceAx : res.timeTrace;
    
    // Safety check for index
    int maxIndex = xTrace.length - 1;
    // Map current time percentage to new track if we switch
    if (_currentIndex > maxIndex) _currentIndex = maxIndex;

    double currentTime = 0.0;
    if (timeTrace.isNotEmpty && _currentIndex < timeTrace.length) {
      currentTime = timeTrace[_currentIndex];
    }

    return Column(
      children: [
        // 1. HEADER & TOGGLE
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DataCard("Current Time", "${currentTime.toStringAsFixed(3)} s"),
              
              Row(
                children: [
                  const Text("Endurance", style: TextStyle(color: Colors.white70)),
                  Switch(
                    value: _showAutocross,
                    activeColor: Colors.orangeAccent,
                    onChanged: (val) {
                      setState(() {
                        _showAutocross = val;
                        _currentIndex = 0;
                      });
                    },
                  ),
                  const Text("Autocross", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),

        // 2. MAP
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              duration: Duration.zero,
              LineChartData(
                lineBarsData: [
                  
                  LineChartBarData(
                    spots: _getTrackPath(xTrace, yTrace),
                    isCurved: false,
                    color: Colors.white24,
                    barWidth: 4,
                    dotData: FlDotData(show: false),
                  ),

                  LineChartBarData(
                    spots: [FlSpot(xTrace[_currentIndex], yTrace[_currentIndex])],
                    color: _showAutocross ? Colors.orangeAccent : Colors.blueAccent,
                    barWidth: 0,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(radius: 6, color: barData.color ?? Colors.white, strokeWidth: 2, strokeColor: Colors.white),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),

        // 3. SLIDER
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Slider(
            value: _currentIndex.toDouble(),
            min: 0,
            max: maxIndex.toDouble(),
            activeColor: _showAutocross ? Colors.orangeAccent : Colors.blueAccent,
            onChanged: (val) => setState(() => _currentIndex = val.toInt()),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getTrackPath(List<double> x, List<double> y) {
    final List<FlSpot> spots = [];
    
    if (x.isEmpty || y.isEmpty) return spots;

    for (int i = 0; i < x.length; i++) {
      double currentX = x[i];
      double currentY = y[i];

      if (currentX == 0.0 && currentY == 0.0) {
        continue; 
      }

      spots.add(FlSpot(currentX, currentY));
    }
    return spots;
  }

  Widget _DataCard(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}