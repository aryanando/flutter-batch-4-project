import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';
import 'package:flutter_batch_4_project/data/local_storage/theme_local_storage.dart';
import 'package:flutter_batch_4_project/data/local_storage/trouble_report_local_storage.dart';
import 'package:flutter_batch_4_project/data/remote_data/auth_remote_data.dart';
import 'package:flutter_batch_4_project/data/remote_data/network_service/network_service.dart';
import 'package:flutter_batch_4_project/data/remote_data/trouble_report_remote_data.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

Future<void> setupInjector() async {
  await hiveInjector();
  localStorageInjector();
  networkInjector();
}

Future<void> hiveInjector() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  var box = await Hive.openBox('app');
  getIt.registerSingleton<Box>(box);
}

void localStorageInjector() {
  getIt.registerSingleton(AuthLocalStorage(getIt.get<Box>()));
  getIt.registerSingleton(ThemeLocalStorage(getIt.get<Box>()));
  // Register the new TroubleReportLocalStorage
  getIt.registerLazySingleton(() => TroubleReportLocalStorage());
}

void networkInjector() {
  final networkService = NetworkService(getIt.get<AuthLocalStorage>());
  getIt.registerSingleton(networkService);
  getIt.registerSingleton<AuthRemoteData>(
      AuthRemoteDataImpl(getIt.get<NetworkService>()));

  // ✅ Register Trouble Report Remote Data
  getIt.registerSingleton<TroubleReportRemoteData>(
      TroubleReportRemoteData(getIt.get<NetworkService>()));

  getIt.registerFactory(() => TroubleReportCubit(
      getIt.get<TroubleReportRemoteData>(),
      getIt.get<TroubleReportLocalStorage>()));
}
