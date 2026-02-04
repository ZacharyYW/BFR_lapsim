import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParamInput extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? units;

  const ParamInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.units,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: value,
              onChanged: onChanged,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,-]')),
              ],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: const OutlineInputBorder(),
                suffixText: units,
              ),
            ),
          ),
        ],
      ),
    );
  }
}