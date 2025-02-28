import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/pages/home/report_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_state.dart';

class AllReportsTab extends StatefulWidget {
  const AllReportsTab({super.key});

  @override
  State<AllReportsTab> createState() => _AllReportsTabState();
}

class _AllReportsTabState extends State<AllReportsTab> {
  @override
  void initState() {
    super.initState();
    context.read<TroubleReportCubit>().loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Reports')),
      body: BlocBuilder<TroubleReportCubit, TroubleReportState>(
        builder: (context, state) {
          if (state is TroubleReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TroubleReportLoaded) {
            return ListView.builder(
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final report = state.reports[index];
                return ListTile(
                    title: Text(report.name),
                    subtitle: Text(report.description),
                    trailing: Text(report.status),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReportDetailPage(report: report),
                        ),
                      );
                    });
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
