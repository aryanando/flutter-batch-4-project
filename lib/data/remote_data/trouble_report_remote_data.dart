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
}
