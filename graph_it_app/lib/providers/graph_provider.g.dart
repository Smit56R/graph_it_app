// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GraphItemAdapter extends TypeAdapter<GraphItem> {
  @override
  final int typeId = 0;

  @override
  GraphItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GraphItem(
      id: fields[0] as String,
      type: fields[1] as TypeOfGraph,
      dateTime: fields[2] as DateTime,
      graph: fields[3] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, GraphItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.graph);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GraphItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
