// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_graph_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarGraphModelAdapter extends TypeAdapter<BarGraphModel> {
  @override
  final int typeId = 3;

  @override
  BarGraphModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarGraphModel(
      data: (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as int, (v as List).cast<Object>())),
      title: fields[1] as String?,
      labelY: fields[2] as String?,
      legend: fields[3] as String?,
      isSaved: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BarGraphModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.labelY)
      ..writeByte(3)
      ..write(obj.legend)
      ..writeByte(4)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarGraphModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
