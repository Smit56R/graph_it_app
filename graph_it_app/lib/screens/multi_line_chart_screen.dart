import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/multi_line_chart_model.dart';
import '../models/type_of_graph.dart';

import '../providers/graph_provider.dart';

import '../widgets/app_back_button.dart';

class Coordinates {
  final double x, y;
  Coordinates(this.x, this.y);
}

class MultiLineChartScreen extends StatefulWidget {
  static const routeName = '/multi-line-chart';

  MultiLineChartScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MultiLineChartScreenState createState() => _MultiLineChartScreenState();
}

class _MultiLineChartScreenState extends State<MultiLineChartScreen> {
  MultiLineChartModel data = MultiLineChartModel(
    multiPoints: [],
    legends: [],
    title: '',
    labelX: '',
    labelY: '',
  );
  final List<Color> gradientColors = [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];
  bool _disableSave = false;
  late TooltipBehavior _tooltipBehavior;
  final _cartesianKey = GlobalKey<SfCartesianChartState>();

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  List<Coordinates> datapoints(int index) {
    final List<Coordinates> l = [];
    for (int i = 1; i <= data.multiPoints[index].length; i++) {
      l.add(Coordinates(
          data.multiPoints[index][i]![0], data.multiPoints[index][i]![1]));
    }
    return l;
  }

  List<LineSeries<Coordinates, double>> get lineSeriesList {
    final List<LineSeries<Coordinates, double>> L = [];
    for (int i = 0; i < data.multiPoints.length; i++) {
      L.add(
        LineSeries<Coordinates, double>(
          name: data.legends[i],
          dataSource: datapoints(i),
          xValueMapper: (c, _) => c.x,
          yValueMapper: (c, _) => c.y,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
          ),
          markerSettings: MarkerSettings(isVisible: true),
          enableTooltip: true,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    return L;
  }

  List<SplineSeries<Coordinates, double>> get splineSeriesList {
    final List<SplineSeries<Coordinates, double>> L = [];
    for (int i = 0; i < data.multiPoints.length; i++) {
      L.add(
        SplineSeries<Coordinates, double>(
          name: data.legends[i],
          dataSource: datapoints(i),
          xValueMapper: (c, _) => c.x,
          yValueMapper: (c, _) => c.y,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
          ),
          markerSettings: MarkerSettings(isVisible: true),
          enableTooltip: true,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    return L;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as MultiLineChartModel;
    _disableSave = data.isSaved;
    final axisLineColor = Theme.of(context).appBarTheme.titleTextStyle!.color;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Line Chart'),
          leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
          actions: [
            IconButton(
              onPressed: _disableSave
                  ? null
                  : () {
                      Provider.of<GraphProvider>(context, listen: false)
                          .saveGraph(data, TypeOfGraph.MultiLineChart);
                      setState(() {
                        data.isSaved = true;
                      });
                    },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SfCartesianChart(
          key: _cartesianKey,
          title: ChartTitle(
            text: data.title!,
            textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          legend: Legend(
            isVisible: true,
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            if (data.isCurved) ...splineSeriesList else ...lineSeriesList,
          ],
          primaryXAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            title: AxisTitle(
              text: data.labelX,
              textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            axisLine: AxisLine(
              color: axisLineColor,
            ),
            labelStyle: TextStyle(color: axisLineColor),
          ),
          primaryYAxis: NumericAxis(
            //edgeLabelPlacement: EdgeLabelPlacement.shift,
            title: AxisTitle(
              text: data.labelY,
              textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            axisLine: AxisLine(
              color: axisLineColor,
            ),
            labelStyle: TextStyle(color: axisLineColor),
          ),
        ),
      ),
    );
  }
}
