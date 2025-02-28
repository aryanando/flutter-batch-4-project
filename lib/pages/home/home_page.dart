import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/blocs/product/product_cubit.dart';
import 'package:flutter_batch_4_project/blocs/sales_invoice/sales_invoice_cubit.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/data/local_storage/trouble_report_local_storage.dart';
import 'package:flutter_batch_4_project/data/remote_data/trouble_report_remote_data.dart';
import 'package:flutter_batch_4_project/pages/home/invoice_tab.dart';
import 'package:flutter_batch_4_project/pages/home/pos_tab.dart';
import 'package:flutter_batch_4_project/pages/home/profile_tab.dart';
import 'package:flutter_batch_4_project/pages/home/report_order_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/injector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;

  final troubleReportCubit = getIt.get<TroubleReportCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => troubleReportCubit),
      ],
      child: Scaffold(
        body: [
          const TroubleReportTab(),
          const TroubleReportTab(),
        ][currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) => setState(() {
            currentIndex = value;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Reports', // New tab label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Reports', // New tab label
            ),
          ],
        ),
      ),
    );
  }
}
