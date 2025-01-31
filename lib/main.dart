import 'package:flutter/material.dart';
import 'package:magic_invest/features/home/home.view.dart';
import 'package:magic_invest/view_models/stock.view_model.dart';
import 'package:provider/provider.dart';

import 'data_sources/stock/stock.datasource.dart';

void main() async {
  await StockPersistence.initHive();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StockViewModel(),
      child: MaterialApp(
        title: 'Magic Invest!',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
        ),
        home: const HomeView(), // Set your initial screen here
      ),
    );
  }
}
