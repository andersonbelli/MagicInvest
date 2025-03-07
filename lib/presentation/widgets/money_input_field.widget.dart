import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/formatters/currency_formatter.dart';

class MoneyInputField extends StatelessWidget {
  const MoneyInputField({
    super.key,
    required this.controller,
    this.label = 'Valor',
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixText: '',
      ),
    );
  }
}
