// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trouble_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TroubleReportAdapter extends TypeAdapter<TroubleReport> {
  @override
  final int typeId = 1;

  @override
  TroubleReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TroubleReport(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      status: fields[3] as String,
      result: fields[4] as String?,
      solvedDate: fields[5] as DateTime?,
      photos: (fields[6] as List).cast<ReportMedia>(),
      videos: (fields[7] as List).cast<ReportMedia>(),
    );
  }

  @override
  void write(BinaryWriter writer, TroubleReport obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.result)
      ..writeByte(5)
      ..write(obj.solvedDate)
      ..writeByte(6)
      ..write(obj.photos)
      ..writeByte(7)
      ..write(obj.videos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TroubleReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportMediaAdapter extends TypeAdapter<ReportMedia> {
  @override
  final int typeId = 2;

  @override
  ReportMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportMedia(
      filePath: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReportMedia obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
