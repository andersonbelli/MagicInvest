import 'package:abelliz_essentials/abelliz_essentials.dart';
import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../../domain/model/stock.model.dart';
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
  final viewModel = getIt.get<StockViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStocks();
    });

    viewModel.errorMessageStream.listen(_listenable);
  }

  _listenable(String? errorMessage) {
    if (errorMessage != null && errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
    }
  }

  void _editStock(StockModel stock) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStockView(stock: stock),
      ),
    );

    _loadStocks();
  }

  void _addNewStock() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddStockScreen(),
      ),
    );

    _loadStocks();
  }

  void _viewStockDetails(StockModel stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailsView(stock: stock),
      ),
    );
  }

  void _deleteStock(StockModel stock) => showMessageDialogAbelliz(
        context,
        'Você tem certeza que deseja excluir esta ação?',
        title: const Text('Confirmar Exclusão'),
        actionButtons: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                Theme.of(context).colorScheme.tertiary,
              ),
            ),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await viewModel.deleteStock(stock);
              _loadStocks();
              if (mounted) Navigator.of(context).pop(true);
            },
            child: const Text('Excluir'),
          ),
        ],
      );

  void _loadStocks() async {
    if (mounted) {
      await viewModel.loadStocks();
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
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, widget) {
          return ListView.builder(
            itemCount: viewModel.stocks.length,
            itemBuilder: (context, index) {
              final stock = viewModel.stocks[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(stock.ticker),
                    subtitle: Text(
                      'Investido: R\$ ${stock.investedAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
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
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () => _viewStockDetails(stock),
                        ),
                      ],
                    ),
                    onTap: () => _viewStockDetails(stock),
                    style: ListTileStyle.drawer,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
