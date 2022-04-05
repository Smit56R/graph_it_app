import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/type_of_graph.dart';

part 'graph_provider.g.dart';

@HiveType(typeId: 0)
class GraphItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final TypeOfGraph type;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  dynamic graph;

  GraphItem({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.graph,
  });
}

class GraphProvider with ChangeNotifier {
  List<GraphItem> _graphs = [];

  List<GraphItem> get graphs {
    return _graphs;
  }

  void fetchAndSetGraphs() {
    final box = Hive.box<GraphItem>('graphs');
    _graphs = box.values.toList().cast<GraphItem>().reversed.toList();
  }

  void saveGraph(dynamic chartItem, TypeOfGraph type) {
    final graphItem = GraphItem(
      id: DateTime.now().toString(),
      type: type,
      dateTime: DateTime.now(),
      graph: chartItem,
    );
    // _graphs.insert(0, graphItem);
    // notifyListeners();

    final box = Hive.box<GraphItem>('graphs');
    box.add(graphItem);
  }

  void deleteGraph(GraphItem graphItem) {
    graphItem.delete();
    fetchAndSetGraphs();
    notifyListeners();
  }
}
