import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../../domain/model/stock.model.dart';
import '../../../shared/currency_utils.dart';
import '../../view_models/stock.view_model.dart';
import '../../widgets/stock_form.widget.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final viewModel = getIt.get<StockViewModel>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tickerController;
  late TextEditingController _dividendYieldController;
  late TextEditingController _investedAmountController;
  late TextEditingController _currentPriceController;

  @override
  void initState() {
    super.initState();
    _tickerController = TextEditingController();
    _dividendYieldController = TextEditingController();
    _investedAmountController = TextEditingController();
    _currentPriceController = TextEditingController();
  }

  @override
  void dispose() {
    _tickerController.dispose();
    _dividendYieldController.dispose();
    _investedAmountController.dispose();
    _currentPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Nova Ação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StockForm(
                tickerController: _tickerController,
                dividendYieldController: _dividendYieldController,
                investedAmountController: _investedAmountController,
                currentPriceController: _currentPriceController,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Adicionar Ação'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newStock = StockModel(
          ticker: _tickerController.text.toUpperCase(),
          dividendYield: double.parse(_dividendYieldController.text.replaceAll(',', '.')),
          investedAmount: parseCurrency(_investedAmountController.text),
          currentPrice: parseCurrency(_currentPriceController.text),
        );

        await viewModel.addStock(newStock);

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar a ação: $e')),
          );
        }
      }
    }
  }
}
