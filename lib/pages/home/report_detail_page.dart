import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/models/trouble_report_model.dart';
import 'package:video_player/video_player.dart';

class ReportDetailPage extends StatefulWidget {
  final TroubleReport report;

  const ReportDetailPage({super.key, required this.report});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  final List<VideoPlayerController> _videoControllers = [];
  late List<bool> _isInitialized;
  late List<bool> _hasError;

  @override
  void initState() {
    super.initState();

    print('🟢 Total Videos: ${widget.report.videos.length}');

    _isInitialized = List.filled(widget.report.videos.length, false);
    _hasError = List.filled(widget.report.videos.length, false);

    for (var i = 0; i < widget.report.videos.length; i++) {
      final videoUrl = widget.report.videos[i].filePath.startsWith('http')
          ? widget.report.videos[i].filePath
          : 'http://10.20.30.6:8081/api/v1/it-trouble-reports/videos/${widget.report.videos[i].filePath.split('/').last}';

      print('🟢 Loading video: $videoUrl');

      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

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
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      if (controller.value.isInitialized) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.report.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
                Icons.description, "Deskripsi", widget.report.description),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.info, "Status", widget.report.status,
                statusColor: widget.report.status == 'solved'
                    ? Colors.green
                    : Colors.orange),
            const SizedBox(height: 12),
            if (widget.report.result != null)
              _buildInfoCard(
                  Icons.check_circle, "Hasil", widget.report.result!),
            const SizedBox(height: 12),

            // Photos Section
            _buildSectionHeader(Icons.photo, "Photos"),
            if (widget.report.photos.isNotEmpty)
              Column(
                children: widget.report.photos.map((photo) {
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
              const Text('Tidak ada foto.',
                  style: TextStyle(fontStyle: FontStyle.italic)),

            const SizedBox(height: 12),

            // Videos Section
            _buildSectionHeader(Icons.videocam, "Videos"),
            if (widget.report.videos.isNotEmpty &&
                _videoControllers.length == widget.report.videos.length)
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
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text('Gagal memuat video.',
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
              const Text('Tidak ada video.',
                  style: TextStyle(fontStyle: FontStyle.italic)),
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
