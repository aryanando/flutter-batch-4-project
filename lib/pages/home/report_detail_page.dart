import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/models/trouble_report_model.dart';

class ReportDetailPage extends StatelessWidget {
  final TroubleReport report;

  const ReportDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(report.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(report.description),
            const SizedBox(height: 10),
            Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(report.status),
            const SizedBox(height: 10),
            if (report.result != null) ...[
              Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(report.result!),
            ],
            const SizedBox(height: 10),
            Text('Photos:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (report.photos.isNotEmpty)
              Column(
                children: report.photos.map((photo) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Image.network(
                      photo.filePath,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              )
            else
              Text('No photos available'),
            const SizedBox(height: 10),
            Text('Videos:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (report.videos.isNotEmpty)
              Column(
                children: report.videos.map((video) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text('Video: ${video.filePath}'),
                  );
                }).toList(),
              )
            else
              Text('No videos available'),
          ],
        ),
      ),
    );
  }
}
