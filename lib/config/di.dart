import 'package:auto_injector/auto_injector.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/data_sources/stock/stock.local_datasource.dart';
import '../data/entity/stock.entity.dart';
import '../data/repositories/stock.repository.dart';
import '../presentation/view_models/stock.view_model.dart';

final getIt = AutoInjector();

registerDependencies() async {
  await _initHive();

  /// DataSources
  getIt.add(StockLocalDatasource.new);

  /// Repositories
  getIt.add<StockRepository>(StockRepositoryImpl.new);

  /// ViewModels
  getIt.add(StockViewModel.new);

  /// Inform that you have finished adding instances
  getIt.commit();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StockAdapter());
}
