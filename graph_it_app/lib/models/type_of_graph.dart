import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'type_of_graph.g.dart';

@HiveType(typeId: 1)
enum TypeOfGraph {
  @HiveField(0)
  LineChart,

  @HiveField(1)
  PieChart,

  @HiveField(2)
  BarGraph,

  @HiveField(3)
  MultiLineChart,
}
