import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_batch_4_project/data/remote_data/network_service/network_service.dart';
import 'package:flutter_batch_4_project/models/trouble_report_model.dart';

class TroubleReportRemoteData {
  final NetworkService networkService;

  TroubleReportRemoteData(this.networkService);

  Future<List<TroubleReport>> fetchTroubleReports() async {
    final response =
        await networkService.get(url: '/api/v1/it-trouble-reports');

    final List<dynamic> data = response.data['data'];
    return data.map((e) => TroubleReport.fromJson(e)).toList();
  }

  Future<void> createTroubleReport({
    required String name,
    required String description,
    required int unitId,
    List<File> photos = const [],
    List<File> videos = const [],
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'unit_id': unitId,
      'photos[]': [
        for (var photo in photos)
          await MultipartFile.fromFile(photo.path,
              filename: photo.path.split('/').last)
      ],
      'videos[]': [
        for (var video in videos)
          await MultipartFile.fromFile(video.path,
              filename: video.path.split('/').last)
      ],
    });

    await networkService.postFormData('/api/v1/it-trouble-reports', formData);
  }

  Future<void> updateReport({
    required String reportId,
    required Map<String, dynamic> data,
  }) async {
    await networkService.put(
      url: '/api/v1/it-trouble-reports/$reportId',
      data: data,
    );
  }

  // ✅ New method to fetch a single report
  Future<TroubleReport?> fetchSingleReport(String reportId) async {
    try {
      print("here $reportId");
      final response = await networkService.get(
        url: '/api/v1/it-trouble-reports/$reportId',
      );

      if (response.data['data'] == null) {
        return null;
      }

      return TroubleReport.fromJson(response.data['data']);
    } catch (e) {
      print('❌ Failed to fetch single report: $e');
      return null; // Safely handle errors
    }
  }
}
