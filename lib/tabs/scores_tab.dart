import 'package:flutter/material.dart';
import '../models/simulation_result.dart';

class ScoresTab extends StatelessWidget {
  final SimulationResult? result;

  const ScoresTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Center(
        child: Text("Run simulation to view scores.", style: TextStyle(color: Colors.white54)),
      );
    }

    final res = result!;
    
    // Derive times where possible (last value of the time trace)
    final enduranceTime = res.timeTrace.isNotEmpty ? res.timeTrace.last : 0.0;
    final autocrossTime = res.timeTraceAx.isNotEmpty ? res.timeTraceAx.last : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TOTAL SCORE HEADER
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade700, Colors.blueAccent.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
              children: [
                const Text("TOTAL SCORE", style: TextStyle(color: Colors.white70, letterSpacing: 1.5, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  res.totalPoints.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const Text("POINTS", style: TextStyle(color: Colors.white30, fontSize: 12)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text("Event Breakdown", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // 2. EVENT GRIDS
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            children: [
              _ScoreCard(
                title: "Endurance",
                score: res.enduranceScore,
                maxScore: 275, // FSAE Rules approx
                color: Colors.greenAccent,
                icon: Icons.timer,
                details: "${enduranceTime.toStringAsFixed(3)} s",
              ),
              _ScoreCard(
                title: "Autocross",
                score: res.autocrossScore,
                maxScore: 125, // FSAE Rules approx
                color: Colors.orangeAccent,
                icon: Icons.flag,
                details: "${autocrossTime.toStringAsFixed(3)} s",
              ),
              _ScoreCard(
                title: "Skidpad",
                score: res.skidpadScore,
                maxScore: 75,
                color: Colors.purpleAccent,
                icon: Icons.loop,
              ),
              _ScoreCard(
                title: "Acceleration",
                score: res.accelerationScore,
                maxScore: 100,
                color: Colors.redAccent,
                icon: Icons.flash_on,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final double score;
  final double maxScore;
  final Color color;
  final IconData icon;
  final String? details;

  const _ScoreCard({
    required this.title,
    required this.score,
    required this.maxScore,
    required this.color,
    required this.icon,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text("$maxScore pts max", style: const TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                score.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(title, style: TextStyle(color: color, fontSize: 14)),
              if (details != null) ...[
                const SizedBox(height: 4),
                Text(details!, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ]
            ],
          ),
        ],
      ),
    );
  }
}