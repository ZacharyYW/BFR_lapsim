import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class GGVDiagram extends StatefulWidget {
  final List<double> latAccel;
  final List<double> longAccel;
  final List<double> velocity; 

  const GGVDiagram({
    super.key,
    required this.latAccel,
    required this.longAccel,
    required this.velocity,
  });

  @override
  State<GGVDiagram> createState() => _GGVDiagramState();
}

class _GGVDiagramState extends State<GGVDiagram> {
  // Camera State
  double _yaw = 0.5;
  double _pitch = 0.5;
  double _scale = 1.0;
  
  // Interaction State
  Offset? _lastFocalPoint;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        clipBehavior: Clip.hardEdge,
        child: GestureDetector(
          onScaleStart: (details) {
            _baseScale = _scale;
            _lastFocalPoint = details.focalPoint;
          },
          onScaleUpdate: (details) {
            setState(() {
              // Zoom
              _scale = (_baseScale * details.scale).clamp(0.5, 5.0);

              // Rotate
              if (_lastFocalPoint != null) {
                final delta = details.focalPoint - _lastFocalPoint!;
                _yaw -= delta.dx * 0.01;
                _pitch = (_pitch + delta.dy * 0.01).clamp(-pi / 2, pi / 2);
                _lastFocalPoint = details.focalPoint;
              }
            });
          },
          child: CustomPaint(
            painter: _GGV3DPainter(
              lat: widget.latAccel,
              long: widget.longAccel,
              vel: widget.velocity,
              yaw: _yaw,
              pitch: _pitch,
              scale: _scale,
            ),
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(12),
              child: const Text(
                "3D GGV (Drag to Rotate, Pinch to Zoom)", 
                style: TextStyle(color: Colors.white38, fontSize: 10)
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GGV3DPainter extends CustomPainter {
  final List<double> lat;
  final List<double> long;
  final List<double> vel;
  final double yaw;
  final double pitch;
  final double scale;

  // Configuration Constants
  static const double _maxG = 2.5; 
  static const double _maxV = 100.0; // ft/s

  _GGV3DPainter({
    required this.lat,
    required this.long,
    required this.vel,
    required this.yaw,
    required this.pitch,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Rotation Matrix
    final rotation = v.Matrix4.identity()
      ..rotateX(pitch)
      ..rotateY(yaw);

    // 1. Draw Grid & Axes first (behind data)
    _drawGrid(canvas, center, size, rotation);

    // 2. Transform & Draw Data Points
    final List<_Point3D> pointsToDraw = [];
    final int count = [lat.length, long.length, vel.length].reduce(min);

    for (int i = 0; i < count; i+=3) { // Slight downsample for performance
      // Normalize:
      // X (Lat): -2.5 to 2.5 -> -1.0 to 1.0
      // Z (Long): -2.5 to 2.5 -> -1.0 to 1.0
      // Y (Vel): 0 to 100 -> -1.0 to 1.0 (flipped because screen Y is down)
      
      double x = lat[i] / _maxG;       
      double z = long[i] / _maxG;      
      double y = -(vel[i] / _maxV * 2.0 - 1.0); // Map 0..100 to 1..-1

      v.Vector3 point = v.Vector3(x, y, z);
      
      // Apply Rotation
      point = rotation.transform3(point);

      // Apply Perspective
      double perspective = 1.0 / (1.0 - point.z * 0.3);
      
      double screenX = center.dx + (point.x * size.width * 0.25 * scale * perspective);
      double screenY = center.dy + (point.y * size.height * 0.25 * scale * perspective);
      
      if (perspective > 0) { // Don't draw points behind camera
        pointsToDraw.add(_Point3D(
          offset: Offset(screenX, screenY),
          color: _getColor(lat[i], long[i]),
          depth: point.z,
          radius: 2.0 * scale * perspective,
        ));
      }
    }

    // Sort by depth (Painter's Algorithm)
    pointsToDraw.sort((a, b) => b.depth.compareTo(a.depth));

    for (var p in pointsToDraw) {
      canvas.drawCircle(p.offset, p.radius, Paint()..color = p.color);
    }
  }

  void _drawGrid(Canvas canvas, Offset center, Size size, v.Matrix4 rotation) {
    final linePaint = Paint()..color = Colors.white12..strokeWidth = 1.0;
    final axisPaint = Paint()..color = Colors.white30..strokeWidth = 1.5;

    // Helper to project and draw line
    void drawLine(v.Vector3 start, v.Vector3 end, Paint paint) {
      final tStart = rotation.transform3(start.clone());
      final tEnd = rotation.transform3(end.clone());
      
      double pStart = 1.0 / (1.0 - tStart.z * 0.3);
      double pEnd = 1.0 / (1.0 - tEnd.z * 0.3);

      if (pStart <= 0 || pEnd <= 0) return; // Clip behind camera

      final oStart = Offset(
        center.dx + (tStart.x * size.width * 0.25 * scale * pStart),
        center.dy + (tStart.y * size.height * 0.25 * scale * pStart),
      );
      final oEnd = Offset(
        center.dx + (tEnd.x * size.width * 0.25 * scale * pEnd),
        center.dy + (tEnd.y * size.height * 0.25 * scale * pEnd),
      );

      canvas.drawLine(oStart, oEnd, paint);
    }

    // Helper to draw text label
    void drawLabel(String text, v.Vector3 pos) {
       final tPos = rotation.transform3(pos.clone());
       double p = 1.0 / (1.0 - tPos.z * 0.3);
       if (p <= 0) return;

       final offset = Offset(
        center.dx + (tPos.x * size.width * 0.25 * scale * p),
        center.dy + (tPos.y * size.height * 0.25 * scale * p),
      );

      final textSpan = TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    // --- Draw Wireframe Box ---
    // Corners: +/- 1.0
    
    // Bottom Face (Vel = 0 -> Y = 1.0)
    drawLine(v.Vector3(-1, 1, -1), v.Vector3(1, 1, -1), linePaint);
    drawLine(v.Vector3(1, 1, -1), v.Vector3(1, 1, 1), linePaint);
    drawLine(v.Vector3(1, 1, 1), v.Vector3(-1, 1, 1), linePaint);
    drawLine(v.Vector3(-1, 1, 1), v.Vector3(-1, 1, -1), linePaint);

    // Top Face (Vel = Max -> Y = -1.0)
    drawLine(v.Vector3(-1, -1, -1), v.Vector3(1, -1, -1), linePaint);
    drawLine(v.Vector3(1, -1, -1), v.Vector3(1, -1, 1), linePaint);
    drawLine(v.Vector3(1, -1, 1), v.Vector3(-1, -1, 1), linePaint);
    drawLine(v.Vector3(-1, -1, 1), v.Vector3(-1, -1, -1), linePaint);

    // Vertical Pillars
    drawLine(v.Vector3(-1, 1, -1), v.Vector3(-1, -1, -1), linePaint);
    drawLine(v.Vector3(1, 1, -1), v.Vector3(1, -1, -1), linePaint);
    drawLine(v.Vector3(1, 1, 1), v.Vector3(1, -1, 1), linePaint);
    drawLine(v.Vector3(-1, 1, 1), v.Vector3(-1, -1, 1), linePaint);

    // --- Draw Axes ---
    // Lat Axis (X)
    drawLine(v.Vector3(-1.2, 1, 0), v.Vector3(1.2, 1, 0), axisPaint);
    drawLabel("Lat G", v.Vector3(1.4, 1, 0));
    drawLabel("-2.5", v.Vector3(-1, 1.1, 0));
    drawLabel("2.5", v.Vector3(1, 1.1, 0));

    // Long Axis (Z)
    drawLine(v.Vector3(0, 1, -1.2), v.Vector3(0, 1, 1.2), axisPaint);
    drawLabel("Long G", v.Vector3(0, 1, 1.4));
    drawLabel("-2.5", v.Vector3(0.2, 1, -1));
    drawLabel("2.5", v.Vector3(0.2, 1, 1));

    // Velocity Axis (Y) - Draw centered
    drawLine(v.Vector3(0, 1, 0), v.Vector3(0, -1.2, 0), axisPaint);
    drawLabel("Speed", v.Vector3(0, -1.4, 0));
    drawLabel("0", v.Vector3(-0.2, 1, 0));
    drawLabel("100", v.Vector3(-0.2, -1, 0));
  }

  Color _getColor(double lat, double long) {
     double intensity = (sqrt(lat*lat + long*long) / 2.5).clamp(0.0, 1.0);
     return HSLColor.fromAHSL(0.8, 200 - (intensity * 200), 1.0, 0.5).toColor();
  }

  @override
  bool shouldRepaint(covariant _GGV3DPainter oldDelegate) {
    return oldDelegate.yaw != yaw || oldDelegate.pitch != pitch || oldDelegate.scale != scale;
  }
}

class _Point3D {
  final Offset offset;
  final Color color;
  final double depth;
  final double radius;

  _Point3D({required this.offset, required this.color, required this.depth, required this.radius});
}