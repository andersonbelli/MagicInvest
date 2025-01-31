import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/stock.model.dart';
import '../../view_models/stock.view_model.dart';
import '../add_new_stock/add_new_stock.view.dart';
import '../details/stock_details.view.dart';
import '../edit_stock/edit_stock.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockViewModel>(context, listen: false).loadStocks();
    });
  }

  void _editStock(Stock stock) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStockView(stock: stock),
      ),
    );
    if (mounted) {
      Provider.of<StockViewModel>(context, listen: false).loadStocks();
    }
  }

  void _addNewStock() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStockScreen(),
      ),
    );

    if (mounted) {
      Provider.of<StockViewModel>(context, listen: false).loadStocks();
    }
  }

  void _viewStockDetails(Stock stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailsView(stock: stock),
      ),
    );
  }

  void _deleteStock(Stock stock) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir esta ação?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await Provider.of<StockViewModel>(context, listen: false)
          .deleteStock(stock);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Carteira de Ações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewStock,
          ),
        ],
      ),
      body: Consumer<StockViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.stocks.length,
            itemBuilder: (context, index) {
              final stock = viewModel.stocks[index];
              return ListTile(
                title: Text(stock.ticker),
                subtitle: Text(
                    'Investido: R\$ ${stock.investedAmount.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editStock(stock),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteStock(stock),
                    ),
                  ],
                ),
                onTap: () => _viewStockDetails(stock),
              );
            },
          );
        },
      ),
    );
  }
}
