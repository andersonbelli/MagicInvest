import 'dart:developer';

import 'package:abelliz_essentials/widgets/dialogs/message_dialog.widget.dart';
import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../../domain/model/stock.model.dart';
import '../../../shared/currency_utils.dart';
import '../../view_models/stock.view_model.dart';
import '../../widgets/stock_form.widget.dart';

class EditStockView extends StatefulWidget {
  final StockModel stock;

  const EditStockView({super.key, required this.stock});

  @override
  _EditStockViewState createState() => _EditStockViewState();
}

class _EditStockViewState extends State<EditStockView> {
  final viewModel = getIt.get<StockViewModel>();

  late TextEditingController _tickerController;
  late TextEditingController _dividendYieldController;
  late TextEditingController _investedAmountController;
  late TextEditingController _currentPriceController;

  @override
  void initState() {
    super.initState();
    _tickerController = TextEditingController(text: widget.stock.ticker);
    _dividendYieldController = TextEditingController(text: widget.stock.dividendYield.toString());
    _investedAmountController = TextEditingController(text: widget.stock.investedAmount.toString());
    _currentPriceController = TextEditingController(text: widget.stock.currentPrice.toString());
  }

  void _saveStock() async {
    final updatedStock = widget.stock.copyWith(
      ticker: _tickerController.text,
      dividendYield: double.parse(_dividendYieldController.text),
      investedAmount: parseCurrency(_investedAmountController.text),
      currentPrice: parseCurrency(_currentPriceController.text),
    );

    if (widget.stock.key != null) {
      await viewModel.updateStock(widget.stock.key!, updatedStock);
    } else {
      showMessageDialogAbelliz(
        context,
        'Ops, nao esqueca de adicionar o ticker a ser salvo',
      );
      log('Error $runtimeType -> Stock KEY IS NULL!');
    }

    if (mounted) Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text('Edit Stock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveStock,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StockForm(
              tickerController: _tickerController,
              dividendYieldController: _dividendYieldController,
              investedAmountController: _investedAmountController,
              currentPriceController: _currentPriceController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveStock,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
