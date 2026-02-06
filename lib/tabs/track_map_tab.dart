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
    
    // Safety check for index
    int maxIndex = xTrace.length - 1;
    // Map current time percentage to new track if we switch
    if (_currentIndex > maxIndex) _currentIndex = maxIndex;

    return Column(
      children: [
        // 1. HEADER & TOGGLE
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DataCard("Track Points", "$_currentIndex / $maxIndex"),
              
              Row(
                children: [
                  const Text("Endurance", style: TextStyle(color: Colors.white70)),
                  Switch(
                    value: _showAutocross,
                    activeColor: Colors.orangeAccent,
                    onChanged: (val) {
                      setState(() {
                        _showAutocross = val;
                        _currentIndex = 0; // Reset scrubber on switch
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
              LineChartData(
                lineBarsData: [
                  // Track Path
                  LineChartBarData(
                    spots: _getTrackPath(xTrace, yTrace),
                    isCurved: true,
                    color: Colors.white24,
                    barWidth: 4,
                    dotData: FlDotData(show: false),
                  ),
                  // Ghost Car
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
    // Downsample for performance (every 5th point)
    for (int i = 0; i < x.length; i += 5) {
      spots.add(FlSpot(x[i], y[i]));
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