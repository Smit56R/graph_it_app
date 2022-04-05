import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'line_chart_model.g.dart';

@HiveType(typeId: 2)
class LineChartModel extends HiveObject {
  @HiveField(0)
  final Map<int, List<double>> points;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? labelX;

  @HiveField(3)
  final String? labelY;

  @HiveField(4)
  final bool isCurved;

  @HiveField(5)
  bool isSaved;

  LineChartModel({
    required this.points,
    required this.title,
    required this.labelX,
    required this.labelY,
    this.isCurved = false,
    this.isSaved = false,
  });
}
