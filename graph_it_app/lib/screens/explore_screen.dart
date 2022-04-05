import 'package:flutter/material.dart';

import '../models/line_chart_model.dart';
import '../models/pie_chart_model.dart';
import '../models/bar_graph_model.dart';
import '../models/multi_line_chart_model.dart';

import './line_chart_screen.dart';
import './pie_chart_screen.dart';
import './bar_graph_screen.dart';
import './multi_line_chart_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/background_builder.dart';

class ExploreScreen extends StatelessWidget {
  static const routeName = '/explore';
  ExploreScreen({Key? key}) : super(key: key);

  final lineChart = LineChartModel(
    points: {
      1: [2012, 1226.73],
      2: [2014, 1258.48],
      3: [2016, 1290.24],
      4: [2018, 1318.68],
      5: [2020, 1347.12],
    },
    title: 'India\'s Population (2012-2020)',
    labelX: 'Year',
    labelY: 'Millions',
    isCurved: true,
    isSaved: true,
  );
  final pieChart = PieChartModel(
    data: {
      1: ['Xiaomi', 26.0],
      2: ['Samsung', 20.0],
      3: ['Vivo', 16.0],
      4: ['Oppo', 11.0],
      5: ['Realme', 11.0],
      6: ['Others', 16.0],
    },
    title: 'Smartphone Market Share in India Q1 2021',
    isSaved: true,
  );
  final barGraph = BarGraphModel(
    data: {
      1: ['United States', 113.0],
      2: ['China', 88.0],
      3: ['Japan', 58.0],
      4: ['Great Britain', 65.0],
      5: ['ROC', 71.0],
      6: ['Australia', 46.0],
      7: ['India', 7.0],
    },
    labelY: 'Number of medals',
    legend: 'Medal Count',
    title: 'Olympics 2020 medal count',
    isSaved: true,
  );

  final multiLineChart = MultiLineChartModel(
    multiPoints: [
      {
        1: [0, 0],
        2: [1, 1],
        3: [2, 2],
        4: [3, 3],
        5: [4, 4],
        6: [5, 5],
      },
      {
        1: [0, 0],
        2: [1, 1],
        3: [2, 4],
        4: [3, 9],
        5: [4, 16],
        6: [5, 25],
      },
      {
        1: [0, 0],
        2: [1, 1],
        3: [2, 8],
        4: [3, 27],
        5: [4, 64],
        6: [5, 125],
      },
    ],
    legends: [
      'y = x',
      'y = x2',
      'y = x3',
    ],
    title: 'Powers of x',
    labelX: 'x',
    labelY: 'y',
    isCurved: true,
    isSaved: true,
  );

  Widget exploreItem(
    BuildContext context,
    String imageName,
    String title,
    String routeName,
    IconData icon,
    dynamic graphModel,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed(routeName, arguments: graphModel),
          child: Image.asset(
            imageName,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Icon(
            icon,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Theme.of(context).canvasColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Explore'),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.view_headline,
                size: 40,
              ),
            ),
          ),
        ),
        drawer: const AppDrawer(),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 1
                      : 2,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            children: [
              exploreItem(
                context,
                'assets/images/line_chart_graphic.jpg',
                lineChart.title!,
                LineChartScreen.routeName,
                Icons.show_chart,
                lineChart,
              ),
              exploreItem(
                  context,
                  'assets/images/pie_chart_graphic.png',
                  pieChart.title!,
                  PieChartScreen.routeName,
                  Icons.pie_chart,
                  pieChart),
              exploreItem(
                  context,
                  'assets/images/bar_chart_graphic.png',
                  barGraph.title!,
                  BarGraphScreen.routeName,
                  Icons.bar_chart,
                  barGraph),
              exploreItem(
                context,
                'assets/images/multi_line_chart_graphic.jpg',
                multiLineChart.title!,
                MultiLineChartScreen.routeName,
                Icons.stacked_line_chart,
                multiLineChart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
