// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pie_chart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PieChartModelAdapter extends TypeAdapter<PieChartModel> {
  @override
  final int typeId = 4;

  @override
  PieChartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PieChartModel(
      data: (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as int, (v as List).cast<Object>())),
      title: fields[1] as String?,
      isSaved: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PieChartModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PieChartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
