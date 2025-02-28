import 'package:flutter_batch_4_project/models/trouble_report_model.dart';

abstract class TroubleReportState {}

class TroubleReportInitial extends TroubleReportState {}

class TroubleReportLoading extends TroubleReportState {}

class TroubleReportLoaded extends TroubleReportState {
  final List<TroubleReport> reports;

  TroubleReportLoaded(this.reports);
}

class TroubleReportError extends TroubleReportState {
  final String message;

  TroubleReportError(this.message);
}
