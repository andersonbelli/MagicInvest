import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../../domain/model/stock.model.dart';
import '../../view_models/stock.view_model.dart';
import '../edit_stock/edit_stock.view.dart';

class StockDetailsView extends StatelessWidget {
  const StockDetailsView({super.key, required this.stock});

  final StockModel stock;

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt.get<StockViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Ação: ${stock.ticker}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStockView(stock: stock),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoCard('Ticker', stock.ticker),
            _buildInfoCard(
              'Preço Atual',
              'R\$ ${stock.currentPrice.toStringAsFixed(2)}',
            ),
            _buildInfoCard(
              'Dividend Yield',
              '${stock.dividendYield.toStringAsFixed(2)}%',
            ),
            const Text('Carteira'),
            _buildInfoCard(
              'Valor Investido',
              'R\$ ${stock.investedAmount.toStringAsFixed(2)}',
              customColor: Colors.green[100],
            ),
            _buildInfoCard(
              'Quantidade de cotas',
              '${viewModel.calculateCurrentStocksQuantity(stock)}',
              customColor: Colors.green[100],
            ),
            _buildInfoCard(
              'Valor aproximado de dividendos (mês)',
              'R\$ ${viewModel.calculateMonthlyDividend(stock).toStringAsFixed(2)}',
              customColor: Colors.blue[100],
            ),
            _buildInfoCard(
              'Porcentagem do Portfólio',
              '${viewModel.calculatePortfolioPercentage(stock).toStringAsFixed(2)}%',
              customColor: Colors.green[100],
            ),
            const Text('Magic Number'),
            _buildInfoCard(
              'Total de cotas necessárias',
              viewModel.calculateMagicNumber(stock).toStringAsFixed(2),
              customColor: Colors.purple[100],
            ),
            _buildInfoCard(
              'Cotas restantes para atingir',
              '${viewModel.calculateStocksNeededForMagicNumber(stock)}',
              customColor: Colors.purple[100],
            ),
            _buildInfoCard(
              'Investimento Adicional Necessário',
              'R\$ ${viewModel.calculateAdditionalInvestmentNeeded(stock).toStringAsFixed(2)}',
              customColor: Colors.purple[100],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value, {
    Color? customColor,
  }) {
    return Card(
      color: customColor ?? Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
