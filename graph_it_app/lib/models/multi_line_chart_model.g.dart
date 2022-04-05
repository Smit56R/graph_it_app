// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_line_chart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MultiLineChartModelAdapter extends TypeAdapter<MultiLineChartModel> {
  @override
  final int typeId = 5;

  @override
  MultiLineChartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultiLineChartModel(
      multiPoints: (fields[0] as List)
          .map((dynamic e) => (e as Map).map((dynamic k, dynamic v) =>
              MapEntry(k as int, (v as List).cast<double>())))
          .toList(),
      legends: (fields[1] as List).cast<String>(),
      title: fields[2] as String?,
      labelX: fields[3] as String?,
      labelY: fields[4] as String?,
      isCurved: fields[5] as bool,
      isSaved: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MultiLineChartModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.multiPoints)
      ..writeByte(1)
      ..write(obj.legends)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.labelX)
      ..writeByte(4)
      ..write(obj.labelY)
      ..writeByte(5)
      ..write(obj.isCurved)
      ..writeByte(6)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiLineChartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
