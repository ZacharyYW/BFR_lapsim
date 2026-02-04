import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_config.dart';
import '../param_input.dart';

class PowertrainTab extends StatefulWidget {
  const PowertrainTab({super.key});

  @override
  State<PowertrainTab> createState() => _PowertrainTabState();
}

class _PowertrainTabState extends State<PowertrainTab> {
  // We use controllers for the lists because they are tricky to parse in real-time
  late TextEditingController _gearController;
  late TextEditingController _torqueController;
  late TextEditingController _rpmController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pt = Provider.of<VehicleNotifier>(context, listen: false).config.powertrain;
    _gearController = TextEditingController(text: pt.gearRatios.join(", "));
    _torqueController = TextEditingController(text: pt.engineTorque.join(", "));
    _rpmController = TextEditingController(text: pt.engineRpm.join(", "));
  }

  @override
  void dispose() {
    _gearController.dispose();
    _torqueController.dispose();
    _rpmController.dispose();
    super.dispose();
  }

  List<double> _parseList(String input) {
    if (input.isEmpty) return [];
    try {
      return input.split(',').map((e) => double.parse(e.trim())).toList();
    } catch (e) {
      return []; // Return empty on parse error to avoid crash
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<VehicleNotifier>(context);
    final pt = notifier.config.powertrain;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Engine & Drivetrain", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(),
        
        ParamInput(
          label: "Primary Reduction",
          value: pt.primaryReduction.toString(),
          onChanged: (val) {
             final v = double.tryParse(val);
             if (v != null) notifier.updatePowertrain(pt.copyWith(primaryReduction: v));
          },
        ),
        ParamInput(
          label: "Final Drive",
          value: pt.finalDrive.toString(),
          onChanged: (val) {
             final v = double.tryParse(val);
             if (v != null) notifier.updatePowertrain(pt.copyWith(finalDrive: v));
          },
        ),
        ParamInput(
          label: "Shift Point",
          value: pt.shiftPoint.toString(),
          units: "RPM",
          onChanged: (val) {
             final v = double.tryParse(val);
             if (v != null) notifier.updatePowertrain(pt.copyWith(shiftPoint: v));
          },
        ),

        const SizedBox(height: 20),
        const Text("Gear Ratios (Comma Separated)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: _gearController,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "3.2, 2.5, 1.8..."),
          onChanged: (val) {
            final list = _parseList(val);
            if (list.isNotEmpty) {
               notifier.updatePowertrain(pt.copyWith(gearRatios: list));
            }
          },
        ),

        const SizedBox(height: 20),
        const Text("Torque Curve (N-m)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: _torqueController,
          maxLines: 3,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "40, 45, 50..."),
          onChanged: (val) {
            final list = _parseList(val);
            if (list.isNotEmpty) {
               notifier.updatePowertrain(pt.copyWith(engineTorque: list));
            }
          },
        ),

        const SizedBox(height: 20),
        const Text("RPM Curve", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: _rpmController,
          maxLines: 3,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "1000, 2000, 3000..."),
           onChanged: (val) {
            final list = _parseList(val);
            if (list.isNotEmpty) {
               notifier.updatePowertrain(pt.copyWith(engineRpm: list));
            }
          },
        ),
      ],
    );
  }
}