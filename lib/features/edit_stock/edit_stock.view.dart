import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/stock.model.dart';
import '../../shared/currency_utils.dart';
import '../../view_models/stock.view_model.dart';
import '../../widgets/stock_form.widget.dart';

class EditStockView extends StatefulWidget {
  final Stock stock;

  const EditStockView({super.key, required this.stock});

  @override
  _EditStockViewState createState() => _EditStockViewState();
}

class _EditStockViewState extends State<EditStockView> {
  late TextEditingController _tickerController;
  late TextEditingController _dividendYieldController;
  late TextEditingController _investedAmountController;
  late TextEditingController _currentPriceController;

  @override
  void initState() {
    super.initState();
    _tickerController = TextEditingController(text: widget.stock.ticker);
    _dividendYieldController =
        TextEditingController(text: widget.stock.dividendYield.toString());
    _investedAmountController =
        TextEditingController(text: widget.stock.investedAmount.toString());
    _currentPriceController =
        TextEditingController(text: widget.stock.currentPrice.toString());
  }

  void _saveStock() async {
    final updatedStock = widget.stock.copyWith(
      ticker: _tickerController.text,
      dividendYield: double.parse(_dividendYieldController.text),
      investedAmount: parseCurrency(_investedAmountController.text),
      currentPrice: parseCurrency(_currentPriceController.text),
    );

    await Provider.of<StockViewModel>(context, listen: false)
        .updateStock(widget.stock.key, updatedStock);

    Navigator.pop(context);
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
        title: Text('Edit Stock'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
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
