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

      _videoControllers
          .add(controller); // 🔥 Fixed - use add() not _videoControllers[i]

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.report.description),
              const SizedBox(height: 10),
              Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.report.status),
              const SizedBox(height: 10),
              if (widget.report.result != null) ...[
                Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.report.result!),
              ],
              const SizedBox(height: 10),

              // Photos Section
              Text('Photos:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (widget.report.photos.isNotEmpty)
                Column(
                  children: widget.report.photos.map((photo) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Image.network(
                          photo.filePath.startsWith('http')
                              ? photo.filePath
                              : 'http://10.20.30.6:8081/storage/${photo.filePath}',
                          height: 150,
                          fit: BoxFit.cover,
                        ));
                  }).toList(),
                )
              else
                Text('No photos available'),

              const SizedBox(height: 10),

              // Videos Section
              Text('Videos:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (widget.report.videos.isNotEmpty &&
                  _videoControllers.length == widget.report.videos.length)
                Column(
                  children: List.generate(_videoControllers.length, (index) {
                    final controller = _videoControllers[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        children: [
                          _hasError[index]
                              ? Text('Error loading video')
                              : (_isInitialized[index] &&
                                      controller.value.isInitialized)
                                  ? AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    )
                                  : const CircularProgressIndicator(),
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
                                icon: Icon(Icons.replay),
                                onPressed: () {
                                  controller.seekTo(Duration.zero);
                                  controller.play();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                )
              else
                Text('No videos available'),
            ],
          ),
        ),
      ),
    );
  }
}
