import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Remove any non-digit characters
    newText = newText.replaceAll(RegExp(r'[^\d]'), '');

    // If the input is empty, return empty value
    if (newText.isEmpty) {
      return TextEditingValue(text: 'R\$ 0.00');
    }

    // Convert to double and format as currency
    double value = double.tryParse(newText) ?? 0.0;
    final formatter =
        NumberFormat.simpleCurrency(locale: "pt_BR", decimalDigits: 2);
    String formattedText = formatter.format(value / 100);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
