import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_config.dart';
import '../param_input.dart';

class ChassisTab extends StatelessWidget {
  const ChassisTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the Notifier (not just the config object)
    // This ensures the UI rebuilds when notifyListeners() is called.
    final notifier = Provider.of<VehicleNotifier>(context);
    final chassis = notifier.config.chassis;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Vehicle Architecture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(),
        
        ParamInput(
          label: "Total Mass (W)",
          value: chassis.totalWeight.toString(),
          units: "lbs",
          onChanged: (val) {
             // Parse the string to double. If parse fails, keep old value.
             final newVal = double.tryParse(val);
             if (newVal != null) {
               // Update the state using the Notifier
               notifier.updateChassis(chassis.copyWith(totalWeight: newVal));
             }
          },
        ),
        ParamInput(
          label: "Weight Dist Front (WDF)",
          value: chassis.weightDistFront.toString(),
          units: "%",
          onChanged: (val) {
             final newVal = double.tryParse(val);
             if (newVal != null) {
               notifier.updateChassis(chassis.copyWith(weightDistFront: newVal));
             }
          }, 
        ),
        ParamInput(
          label: "CG Height",
          value: chassis.cgHeight.toString(),
          units: "ft",
          onChanged: (val) {
             final newVal = double.tryParse(val);
             if (newVal != null) {
               notifier.updateChassis(chassis.copyWith(cgHeight: newVal));
             }
          },
        ),
        ParamInput(
          label: "Wheelbase (l)",
          value: chassis.wheelbase.toString(),
          units: "ft",
          onChanged: (val) {
             final newVal = double.tryParse(val);
             if (newVal != null) {
               notifier.updateChassis(chassis.copyWith(wheelbase: newVal));
             }
          },
        ),
        const SizedBox(height: 20),
        const Text("Track Widths", style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(),
        ParamInput(
          label: "Front Track",
          value: chassis.trackWidthFront.toString(),
          units: "ft",
          onChanged: (val) {
             final newVal = double.tryParse(val);
             if (newVal != null) {
               notifier.updateChassis(chassis.copyWith(trackWidthFront: newVal));
             }
          },
        ),
        ParamInput(
          label: "Rear Track",
          value: chassis.trackWidthRear.toString(),
          units: "ft",
          onChanged: (val) {
             final newVal = double.tryParse(val);
             if (newVal != null) {
               notifier.updateChassis(chassis.copyWith(trackWidthRear: newVal));
             }
          },
        ),
      ],
    );
  }
}