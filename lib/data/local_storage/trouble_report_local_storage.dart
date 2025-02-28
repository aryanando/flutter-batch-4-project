import 'package:hive/hive.dart';
import 'package:flutter_batch_4_project/models/trouble_report_model.dart';

class TroubleReportLocalStorage {
  static const String boxName = 'trouble_reports';

  Future<void> saveReports(List<TroubleReport> reports) async {
    final box = await Hive.openBox<TroubleReport>(boxName);
    await box.clear(); // Clear old data before saving new
    await box.addAll(reports);
  }

  Future<List<TroubleReport>> getReports() async {
    final box = await Hive.openBox<TroubleReport>(boxName);
    return box.values.toList();
  }
}
