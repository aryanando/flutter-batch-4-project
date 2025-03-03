import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/blocs/trouble_report/trouble_report_cubit.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';
import 'package:flutter_batch_4_project/helpers/injector.dart';
import 'package:flutter_batch_4_project/models/trouble_report_model.dart';
import 'package:flutter_batch_4_project/pages/home/update_report_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class ReportDetailPage extends StatefulWidget {
  final String reportId;

  const ReportDetailPage({super.key, required this.reportId});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  TroubleReport? report;
  final List<VideoPlayerController> _videoControllers = [];
  late List<bool> _isInitialized;
  late List<bool> _hasError;

  @override
  void initState() {
    super.initState();
    _fetchReportDetails();
  }

  Future<void> _fetchReportDetails() async {
    final refreshedReport = await context
        .read<TroubleReportCubit>()
        .fetchSingleReport(widget.reportId);

    if (refreshedReport != null) {
      setState(() {
        report = refreshedReport;

        // Initialize videos
        _videoControllers.clear();
        _isInitialized = List.filled(report!.videos.length, false);
        _hasError = List.filled(report!.videos.length, false);

        for (var i = 0; i < report!.videos.length; i++) {
          final videoUrl = report!.videos[i].filePath.startsWith('http')
              ? report!.videos[i].filePath
              : 'http://10.20.30.6:8081/api/v1/it-trouble-reports/videos/${report!.videos[i].filePath.split('/').last}';

          final controller =
              VideoPlayerController.networkUrl(Uri.parse(videoUrl));

          _videoControllers.add(controller);

          controller.initialize().then((_) {
            if (mounted) {
              setState(() {
                _isInitialized[i] = true;
              });
            }
          }).catchError((error) {
            print('🔴 Video Error: $error');
            if (mounted) {
              setState(() {
                _hasError[i] = true;
              });
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = getIt.get<AuthLocalStorage>().getUser();
    final isTechnician = currentUser?.unitId == 20;

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Report Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(report!.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
                Icons.description, "Description", report!.description),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.info, "Status", report!.status,
                statusColor:
                    report!.status == 'solved' ? Colors.green : Colors.orange),
            const SizedBox(height: 12),
            if (report!.result != null)
              _buildInfoCard(Icons.check_circle, "Result", report!.result!),
            const SizedBox(height: 12),
            _buildSectionHeader(Icons.photo, "Photos"),
            if (report!.photos.isNotEmpty)
              Column(
                children: report!.photos.map((photo) {
                  final photoUrl = photo.filePath.startsWith('http')
                      ? photo.filePath
                      : 'http://10.20.30.6:8081/storage/${photo.filePath}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(photoUrl,
                          height: 150, fit: BoxFit.cover),
                    ),
                  );
                }).toList(),
              )
            else
              const Text('No photos available.',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            _buildSectionHeader(Icons.videocam, "Videos"),
            if (report!.videos.isNotEmpty &&
                _videoControllers.length == report!.videos.length)
              Column(
                children: List.generate(_videoControllers.length, (index) {
                  final controller = _videoControllers[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Card(
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_hasError[index])
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text('Failed to load video',
                                  style: TextStyle(color: Colors.red)),
                            )
                          else if (_isInitialized[index] &&
                              controller.value.isInitialized)
                            AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          if (_isInitialized[index])
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  onPressed: () {
                                    setState(() {
                                      controller.value.isPlaying
                                          ? controller.pause()
                                          : controller.play();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.replay),
                                  onPressed: () {
                                    controller.seekTo(Duration.zero);
                                    controller.play();
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              )
            else
              const Text('No videos available.',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            if (isTechnician)
              ElevatedButton.icon(
                icon: const Icon(Icons.build),
                label: const Text('Update Report'),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateReportPage(report: report!),
                    ),
                  );

                  if (result == true) {
                    await _fetchReportDetails(); // Reload the report after successful update
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content,
      {Color? statusColor}) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: statusColor ?? Colors.blueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(content,
                      style: TextStyle(
                          fontSize: 14, color: statusColor ?? Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
