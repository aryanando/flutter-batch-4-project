import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/blocs/auth/auth_cubit.dart';
import 'package:flutter_batch_4_project/blocs/order/order_cubit.dart';
import 'package:flutter_batch_4_project/blocs/theme/theme_cubit.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/consts/routes.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';
import 'package:flutter_batch_4_project/data/local_storage/trouble_report_local_storage.dart';
import 'package:flutter_batch_4_project/data/remote_data/auth_remote_data.dart';
import 'package:flutter_batch_4_project/data/remote_data/trouble_report_remote_data.dart';
import 'package:flutter_batch_4_project/helpers/injector.dart';
import 'package:flutter_batch_4_project/helpers/themes/dark_theme.dart';
import 'package:flutter_batch_4_project/helpers/themes/light_theme.dart';
import 'package:flutter_batch_4_project/models/trouble_report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  print("✅ ENV LOADED");
  print("API_BASE_URL: ${dotenv.env['API_BASE_URL']}");

  // Ensure Hive is initialized (already in your injector).
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // ✅ REGISTER ADAPTERS
  Hive.registerAdapter(TroubleReportAdapter());
  Hive.registerAdapter(ReportMediaAdapter());
  // await clearTroubleReportsBox();
  await setupInjector();

  runApp(const MyApp());
}

Future<void> clearTroubleReportsBox() async {
  final box = await Hive.openBox('trouble_reports');
  await box.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthCubit(
                  getIt.get<AuthLocalStorage>(),
                  getIt.get<AuthRemoteData>(),
                )),
        BlocProvider(create: (context) => OrderCubit(getIt.get())),
        BlocProvider(
          create: (context) => ThemeCubit(getIt.get())..init(),
        ),
        BlocProvider(
          create: (context) => TroubleReportCubit(
            getIt.get<TroubleReportRemoteData>(),
            getIt.get<TroubleReportLocalStorage>(),
          )..loadReports(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, themeMode) {
        return MaterialApp(
          title: 'Nusacodes Batch 2',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: lightTheme(context),
          darkTheme: darkTheme(context),
          initialRoute: AppRoutes.splash,
          routes: routes,
        );
      }),
    );
  }
}
