import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_state.dart';

class TroubleReportTab extends StatefulWidget {
  const TroubleReportTab({super.key});

  @override
  State<TroubleReportTab> createState() => _TroubleReportTabState();
}

class _TroubleReportTabState extends State<TroubleReportTab> {
  @override
  void initState() {
    super.initState();
    context.read<TroubleReportCubit>().loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT Trouble Reports')),
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
