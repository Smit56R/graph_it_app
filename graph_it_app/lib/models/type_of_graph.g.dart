// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_of_graph.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TypeOfGraphAdapter extends TypeAdapter<TypeOfGraph> {
  @override
  final int typeId = 1;

  @override
  TypeOfGraph read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TypeOfGraph.LineChart;
      case 1:
        return TypeOfGraph.PieChart;
      case 2:
        return TypeOfGraph.BarGraph;
      case 3:
        return TypeOfGraph.MultiLineChart;
      default:
        return TypeOfGraph.LineChart;
    }
  }

  @override
  void write(BinaryWriter writer, TypeOfGraph obj) {
    switch (obj) {
      case TypeOfGraph.LineChart:
        writer.writeByte(0);
        break;
      case TypeOfGraph.PieChart:
        writer.writeByte(1);
        break;
      case TypeOfGraph.BarGraph:
        writer.writeByte(2);
        break;
      case TypeOfGraph.MultiLineChart:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeOfGraphAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
