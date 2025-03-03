import 'package:flutter_batch_4_project/models/trouble_report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_batch_4_project/data/remote_data/trouble_report_remote_data.dart';
import 'package:flutter_batch_4_project/data/local_storage/trouble_report_local_storage.dart';
// import 'package:flutter_batch_4_project/models/trouble_report_model.dart';

import 'trouble_report_state.dart';

class TroubleReportCubit extends Cubit<TroubleReportState> {
  final TroubleReportRemoteData remoteData;
  final TroubleReportLocalStorage localStorage;

  TroubleReportCubit(this.remoteData, this.localStorage)
      : super(TroubleReportInitial());

  Future<void> loadReports() async {
    emit(TroubleReportLoading());

    try {
      // First try to fetch from API
      final reports = await remoteData.fetchTroubleReports();
      await localStorage.saveReports(reports); // Cache them in Hive
      emit(TroubleReportLoaded(reports));
    } catch (e) {
      // If API fails, try loading from local storage
      final cachedReports = await localStorage.getReports();
      if (cachedReports.isNotEmpty) {
        emit(TroubleReportLoaded(cachedReports));
      } else {
        emit(TroubleReportError('Failed to fetch reports: $e'));
      }
    }
  }

  Future<TroubleReport?> fetchSingleReport(String reportId) async {
    return await remoteData.fetchSingleReport(reportId);
  }
}
