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
}
