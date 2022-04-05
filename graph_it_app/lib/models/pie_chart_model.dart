import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'pie_chart_model.g.dart';

@HiveType(typeId: 4)
class PieChartModel extends HiveObject {
  @HiveField(0)
  final Map<int, List<Object>> data;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  bool isSaved;

  PieChartModel({
    required this.data,
    required this.title,
    this.isSaved = false,
  });
}
