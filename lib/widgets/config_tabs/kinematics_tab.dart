import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_config.dart';
import '../param_input.dart';

class KinematicsTab extends StatelessWidget {
  const KinematicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<VehicleNotifier>(context);
    final k = notifier.config.kinematics;

    // Helper to update specific fields cleanly
    void update(KinematicsConfig newK) => notifier.updateKinematics(newK);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Ride Rates", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(),
        ParamInput(
          label: "Front Ride Rate (WRF)",
          value: k.rideRateFront.toString(),
          units: "lbs/in",
          onChanged: (val) {
            final v = double.tryParse(val);
            if (v != null) update(k.copyWith(rideRateFront: v));
          },
        ),
        ParamInput(
          label: "Rear Ride Rate (WRR)",
          value: k.rideRateRear.toString(),
          units: "lbs/in",
          onChanged: (val) {
            final v = double.tryParse(val);
            if (v != null) update(k.copyWith(rideRateRear: v));
          },
        ),

        const SizedBox(height: 20),
        const Text("Roll & Pitch Gradients", style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(),
        ParamInput(
          label: "Front Roll Gradient",
          value: k.rollGradientFront.toString(),
          units: "deg/g",
          onChanged: (val) {
            final v = double.tryParse(val);
            if (v != null) update(k.copyWith(rollGradientFront: v));
          },
        ),
        ParamInput(
          label: "Rear Roll Gradient",
          value: k.rollGradientRear.toString(),
          units: "deg/g",
          onChanged: (val) {
            final v = double.tryParse(val);
            if (v != null) update(k.copyWith(rollGradientRear: v));
          },
        ),

        const SizedBox(height: 20),
        const Text("Alignment", style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(),
        ParamInput(
          label: "Front Static Camber",
          value: k.staticCamberFront.toString(),
          units: "deg",
          onChanged: (val) {
            final v = double.tryParse(val);
            if (v != null) update(k.copyWith(staticCamberFront: v));
          },
        ),
        ParamInput(
          label: "Rear Static Camber",
          value: k.staticCamberRear.toString(),
          units: "deg",
          onChanged: (val) {
            final v = double.tryParse(val);
            if (v != null) update(k.copyWith(staticCamberRear: v));
          },
        ),
         ParamInput(
          label: "Front Camber Gain",
          value: k.camberGainFront.toString(),
          units: "%",
          onChanged: (val) {
            final v = double.tryParse(val);
            if (v != null) update(k.copyWith(camberGainFront: v));
          },
        ),
      ],
    );
  }
}