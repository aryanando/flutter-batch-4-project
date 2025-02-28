import 'package:hive/hive.dart';

part 'trouble_report_model.g.dart'; // Needed for generated adapter

@HiveType(typeId: 1) // Unique typeId for TroubleReport
class TroubleReport {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final String? result;

  @HiveField(5)
  final DateTime? solvedDate;

  @HiveField(6)
  final List<ReportMedia> photos;

  @HiveField(7)
  final List<ReportMedia> videos;

  TroubleReport({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.result,
    this.solvedDate,
    required this.photos,
    required this.videos,
  });

  factory TroubleReport.fromJson(Map<String, dynamic> json) {
    return TroubleReport(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      result: json['result'],
      solvedDate: json['solved_date'] != null
          ? DateTime.parse(json['solved_date'])
          : null,
      photos: (json['media'] as List)
          .where((m) => m['type'] == 'photo')
          .map((m) => ReportMedia.fromJson(m))
          .toList(),
      videos: (json['media'] as List)
          .where((m) => m['type'] == 'video')
          .map((m) => ReportMedia.fromJson(m))
          .toList(),
    );
  }
}

@HiveType(typeId: 2) // Unique typeId for ReportMedia
class ReportMedia {
  @HiveField(0)
  final String filePath;

  ReportMedia({required this.filePath});

  factory ReportMedia.fromJson(Map<String, dynamic> json) {
    return ReportMedia(filePath: json['file_path']);
  }
}
