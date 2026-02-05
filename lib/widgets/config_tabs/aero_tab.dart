import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laptime_simulator/models/vehicle_config.dart'; 
import 'package:laptime_simulator/widgets/param_input.dart';
import 'package:laptime_simulator/notifiers/vehicle_notifier.dart';

class AeroTab extends StatelessWidget {
  const AeroTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Now the compiler knows what VehicleNotifier is
    final notifier = Provider.of<VehicleNotifier>(context); 
    final aero = notifier.config.aero;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Aerodynamics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(),

        ParamInput(
          label: "Lift Coeff * Area (Cl)",
          value: aero.clArea.toString(),
          units: "ft²",
          onChanged: (val) {
            final newVal = double.tryParse(val);
            if (newVal != null) {
              notifier.updateAero(aero.copyWith(clArea: newVal));
            }
          },
        ),
        ParamInput(
          label: "Drag Coeff * Area (Cd)",
          value: aero.cdArea.toString(),
          units: "ft²",
          onChanged: (val) {
            final newVal = double.tryParse(val);
            if (newVal != null) {
              notifier.updateAero(aero.copyWith(cdArea: newVal));
            }
          },
        ),
        ParamInput(
          label: "Front Downforce Dist (CoP)",
          value: aero.centerOfPressure.toString(),
          units: "%",
          onChanged: (val) {
            final newVal = double.tryParse(val);
            if (newVal != null) {
              notifier.updateAero(aero.copyWith(centerOfPressure: newVal));
            }
          },
        ),
      ],
    );
  }
}