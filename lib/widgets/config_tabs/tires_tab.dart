import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_config.dart';
import '../param_input.dart';

class TireTab extends StatelessWidget {
  const TireTab({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<VehicleNotifier>(context);
    final tires = notifier.config.tires;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Tire Model", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(),

        ParamInput(
          label: "Tire Radius",
          value: tires.tireRadius.toString(),
          units: "ft",
          onChanged: (val) {
            final newVal = double.tryParse(val);
            if (newVal != null) {
              notifier.updateTires(tires.copyWith(tireRadius: newVal));
            }
          },
        ),
        
        const SizedBox(height: 20),
        const Text("Grip Scaling Factors", style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(),
        
        ParamInput(
          label: "Longitudinal Grip (sf_x)",
          value: tires.scalingFactorX.toString(),
          units: "0.0-1.0",
          onChanged: (val) {
            final newVal = double.tryParse(val);
            if (newVal != null) {
              notifier.updateTires(tires.copyWith(scalingFactorX: newVal));
            }
          },
        ),
        ParamInput(
          label: "Lateral Grip (sf_y)",
          value: tires.scalingFactorY.toString(),
          units: "0.0-1.0",
          onChanged: (val) {
            final newVal = double.tryParse(val);
            if (newVal != null) {
              notifier.updateTires(tires.copyWith(scalingFactorY: newVal));
            }
          },
        ),
      ],
    );
  }
}