import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'money_input_field.widget.dart';

class StockForm extends StatelessWidget {
  const StockForm({
    super.key,
    required this.tickerController,
    required this.dividendYieldController,
    required this.investedAmountController,
    required this.currentPriceController,
  });

  final TextEditingController tickerController;
  final TextEditingController dividendYieldController;
  final TextEditingController investedAmountController;
  final TextEditingController currentPriceController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: tickerController,
          decoration: const InputDecoration(labelText: 'Ticker'),
          validator: (value) => value!.isEmpty ? 'Digite o ticker' : null,
        ),
        TextFormField(
          controller: dividendYieldController,
          decoration: const InputDecoration(labelText: 'Dividend Yield (%)'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              final String newText = newValue.text.replaceAll(',', '.');
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }),
          ],
          validator: (value) => value!.isEmpty ? 'Digite o Dividend Yield' : null,
        ),
        MoneyInputField(
          controller: investedAmountController,
          label: 'Investido',
        ),
        MoneyInputField(
          controller: currentPriceController,
          label: 'Preço Atual',
        ),
      ],
    );
  }
}
