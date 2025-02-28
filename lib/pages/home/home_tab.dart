import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';
import 'package:flutter_batch_4_project/helpers/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_state.dart';
import 'package:flutter_batch_4_project/pages/home/report_detail_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    context.read<TroubleReportCubit>().loadReports();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = getIt.get<AuthLocalStorage>().getUser()?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('My Reports')),
      body: BlocBuilder<TroubleReportCubit, TroubleReportState>(
        builder: (context, state) {
          if (state is TroubleReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TroubleReportLoaded) {
            final myReports = state.reports
                .where((report) => report.userId == currentUserId)
                .toList();

            return ListView.builder(
              itemCount: myReports.length,
              itemBuilder: (context, index) {
                final report = myReports[index];
                return ListTile(
                  title: Text(report.name),
                  subtitle: Text(report.description),
                  trailing: Text(report.status),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetailPage(report: report),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is TroubleReportError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No reports available.'));
        },
      ),
    );
  }
}
