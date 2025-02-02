import 'package:flutter/material.dart';

import 'config/di.dart';
import 'presentation/features/home/home.view.dart';

void main() async {
  await registerDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Invest!',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: const HomeView(),
    );
  }
}
