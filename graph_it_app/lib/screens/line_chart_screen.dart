import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/line_chart_model.dart';
import '../models/type_of_graph.dart';

import '../providers/graph_provider.dart';

import '../widgets/app_back_button.dart';

class Coordinates {
  final double x, y;
  Coordinates(this.x, this.y);
}

class LineChartScreen extends StatefulWidget {
  static const routeName = '/line-chart';

  LineChartScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LineChartScreenState createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen> {
  LineChartModel data = LineChartModel(
    points: {},
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

  List<Coordinates> get datapoints {
    final List<Coordinates> l = [];
    for (int i = 1; i <= data.points.length; i++) {
      l.add(Coordinates(data.points[i]![0], data.points[i]![1]));
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as LineChartModel;
    _disableSave = data.isSaved;
    final axisLineColor = Theme.of(context).appBarTheme.titleTextStyle!.color;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Line Chart'),
          leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
          actions: [
            IconButton(
              onPressed: _disableSave
                  ? null
                  : () {
                      Provider.of<GraphProvider>(context, listen: false)
                          .saveGraph(data, TypeOfGraph.LineChart);
                      setState(() {
                        data.isSaved = true;
                      });
                    },
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: SfCartesianChart(
          key: _cartesianKey,
          title: ChartTitle(
            text: data.title!,
            //backgroundColor: Colors.amber,
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
            if (data.isCurved)
              SplineSeries<Coordinates, double>(
                name: data.title,
                dataSource: datapoints,
                xValueMapper: (c, _) => c.x,
                yValueMapper: (c, _) => c.y,
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                ),
                markerSettings: MarkerSettings(
                  isVisible: true,
                ),
                enableTooltip: true,
                color: Theme.of(context).primaryColor,
              )
            else
              LineSeries<Coordinates, double>(
                name: data.title,
                dataSource: datapoints,
                xValueMapper: (c, _) => c.x,
                yValueMapper: (c, _) => c.y,
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                ),
                markerSettings: MarkerSettings(isVisible: true),
                enableTooltip: true,
                color: Theme.of(context).primaryColor,
              ),
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
