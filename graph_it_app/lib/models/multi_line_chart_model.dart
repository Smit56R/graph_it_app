import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'multi_line_chart_model.g.dart';

@HiveType(typeId: 5)
class MultiLineChartModel extends HiveObject {
  @HiveField(0)
  final List<Map<int, List<double>>> multiPoints;

  @HiveField(1)
  final List<String> legends;

  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String? labelX;

  @HiveField(4)
  final String? labelY;

  @HiveField(5)
  final bool isCurved;

  @HiveField(6)
  bool isSaved;

  MultiLineChartModel({
    required this.multiPoints,
    required this.legends,
    required this.title,
    required this.labelX,
    required this.labelY,
    this.isCurved = false,
    this.isSaved = false,
  });
}
