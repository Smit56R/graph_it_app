import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/app_drawer.dart';
import '../widgets/background_builder.dart';

import '../providers/graph_provider.dart';

import '../models/type_of_graph.dart';

import './line_chart_screen.dart';
import './pie_chart_screen.dart';
import './bar_graph_screen.dart';
import './multi_line_chart_screen.dart';

class SavedGraphsScreen extends StatefulWidget {
  static const routeName = '/saved-graphs';
  const SavedGraphsScreen({Key? key}) : super(key: key);

  @override
  _SavedGraphsScreenState createState() => _SavedGraphsScreenState();
}

class _SavedGraphsScreenState extends State<SavedGraphsScreen> {
  bool _initVal = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initVal) {
      Provider.of<GraphProvider>(context, listen: false).fetchAndSetGraphs();
      _initVal = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final graphData = Provider.of<GraphProvider>(context);
    return BackgroundBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Your Saved Graphs',
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.view_headline,
                size: 40,
              ),
            ),
          ),
        ),
        drawer: const AppDrawer(),
        body: ListView.builder(
          itemCount: graphData.graphs.length,
          itemBuilder: (context, index) => SavedGraphCard(
            graphData: graphData,
            graphItem: graphData.graphs[index],
            index: index,
          ),
        ),
      ),
    );
  }
}

class SavedGraphCard extends StatelessWidget {
  const SavedGraphCard({
    Key? key,
    required this.graphData,
    required this.graphItem,
    required this.index,
  }) : super(key: key);

  final GraphProvider graphData;
  final GraphItem graphItem;
  final index;

  IconData get icon {
    switch (graphItem.type) {
      case TypeOfGraph.LineChart:
        return Icons.show_chart;
      case TypeOfGraph.BarGraph:
        return Icons.bar_chart;
      case TypeOfGraph.PieChart:
        return Icons.pie_chart;
      case TypeOfGraph.MultiLineChart:
        return Icons.stacked_line_chart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          color: Theme.of(context).canvasColor,
          elevation: 2,
          child: ListTile(
            leading: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            title: InkWell(
              child: Text(
                graphItem.graph.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onTap: () {
                String routeName = '/';
                switch (graphItem.type) {
                  case TypeOfGraph.LineChart:
                    routeName = LineChartScreen.routeName;
                    break;
                  case TypeOfGraph.PieChart:
                    routeName = PieChartScreen.routeName;
                    break;
                  case TypeOfGraph.BarGraph:
                    routeName = BarGraphScreen.routeName;
                    break;
                  case TypeOfGraph.MultiLineChart:
                    routeName = MultiLineChartScreen.routeName;
                    break;
                }
                Navigator.of(context)
                    .pushNamed(routeName, arguments: graphItem.graph);
              },
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(graphItem.dateTime),
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('NO')),
                    TextButton(
                        onPressed: () {
                          graphData.deleteGraph(graphItem);
                          Navigator.of(context).pop();
                        },
                        child: const Text('YES')),
                  ],
                ),
              ),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
