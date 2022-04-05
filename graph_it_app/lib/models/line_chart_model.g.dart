// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_chart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LineChartModelAdapter extends TypeAdapter<LineChartModel> {
  @override
  final int typeId = 2;

  @override
  LineChartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LineChartModel(
      points: (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as int, (v as List).cast<double>())),
      title: fields[1] as String?,
      labelX: fields[2] as String?,
      labelY: fields[3] as String?,
      isCurved: fields[4] as bool,
      isSaved: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LineChartModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.points)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.labelX)
      ..writeByte(3)
      ..write(obj.labelY)
      ..writeByte(4)
      ..write(obj.isCurved)
      ..writeByte(5)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineChartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
