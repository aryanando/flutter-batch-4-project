import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/helpers/injector.dart';
import 'package:flutter_batch_4_project/pages/home/home_tab.dart';
import 'package:flutter_batch_4_project/pages/home/all_reports_tab.dart';
import 'package:flutter_batch_4_project/pages/home/profile_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;

  final troubleReportCubit = TroubleReportCubit(getIt.get(), getIt.get());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => troubleReportCubit),
      ],
      child: Scaffold(
        body: [
          const HomeTab(), // My Reports (owned by user)
          const AllReportsTab(), // All Reports for IT department
          const ProfileTab(), // User Profile
        ][currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) => setState(() {
            currentIndex = value;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'My Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'All Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
