import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'bar_graph_model.g.dart';

@HiveType(typeId: 3)
class BarGraphModel extends HiveObject {
  @HiveField(0)
  final Map<int, List<Object>> data;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? labelY;

  @HiveField(3)
  final String? legend;

  @HiveField(4)
  bool isSaved;

  BarGraphModel({
    required this.data,
    required this.title,
    required this.labelY,
    required this.legend,
    this.isSaved = false,
  });
}
