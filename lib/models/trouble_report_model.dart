import 'package:hive/hive.dart';

part 'trouble_report_model.g.dart';

@HiveType(typeId: 1)
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

  @HiveField(8) // New field for user ID
  final int userId; // <-- This is the missing field you need

  TroubleReport({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.result,
    this.solvedDate,
    required this.photos,
    required this.videos,
    required this.userId, // Make sure it's required
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
      userId: json['user_id'], // Make sure you parse this
    );
  }
}

@HiveType(typeId: 2)
class ReportMedia {
  @HiveField(0)
  final String filePath;

  ReportMedia({required this.filePath});

  factory ReportMedia.fromJson(Map<String, dynamic> json) {
    return ReportMedia(filePath: json['file_path']);
  }

  Map<String, dynamic> toJson() => {
        'file_path': filePath,
      };
}
