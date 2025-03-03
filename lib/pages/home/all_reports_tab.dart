import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/pages/home/report_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_state.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';
import 'package:flutter_batch_4_project/helpers/injector.dart';

class AllReportsTab extends StatefulWidget {
  const AllReportsTab({super.key});

  @override
  State<AllReportsTab> createState() => _AllReportsTabState();
}

class _AllReportsTabState extends State<AllReportsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool isTechnician;

  @override
  void initState() {
    super.initState();
    context.read<TroubleReportCubit>().loadReports();
    _tabController = TabController(length: 3, vsync: this);

    final currentUser = getIt.get<AuthLocalStorage>().getUser();
    isTechnician = currentUser?.unitId == 20;
  }

  Future<void> _refreshReports() async {
    context.read<TroubleReportCubit>().loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'On Progress'),
            Tab(text: 'Solved'),
          ],
        ),
      ),
      body: BlocBuilder<TroubleReportCubit, TroubleReportState>(
        builder: (context, state) {
          if (state is TroubleReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TroubleReportLoaded) {
            if (state.reports.isEmpty) {
              return const Center(child: Text('Tidak ada laporan.'));
            }

            final pendingReports = state.reports
                .where((report) => report.status == 'pending')
                .toList();

            final progressReports = state.reports
                .where((report) => report.status == 'in_progress')
                .toList();

            final solvedReports = state.reports
                .where((report) => report.status == 'solved')
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildReportList(pendingReports),
                _buildReportList(progressReports),
                _buildReportList(solvedReports),
              ],
            );
          } else if (state is TroubleReportError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Gagal memuat laporan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _refreshReports,
                      child: const Text('Coba Lagi'),
                    )
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Tidak ada laporan tersedia.'));
        },
      ),
    );
  }

  Widget _buildReportList(List reports) {
    if (reports.isEmpty) {
      return const Center(child: Text('No reports available.'));
    }

    return RefreshIndicator(
      onRefresh: _refreshReports,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                report.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${report.status}',
                    style: TextStyle(
                      color: report.status == 'solved'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: isTechnician
                  ? const Icon(
                      Icons.build,
                    )
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReportDetailPage(reportId: report.id.toString()),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
