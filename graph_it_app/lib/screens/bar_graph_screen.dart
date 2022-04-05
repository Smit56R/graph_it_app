import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

import '../models/bar_graph_model.dart';
import '../models/type_of_graph.dart';

import '../providers/graph_provider.dart';

import '../widgets/app_back_button.dart';

class Data {
  final String label;
  final double value;
  Data(this.label, this.value);
}

class BarGraphScreen extends StatefulWidget {
  static const routeName = '/bar-graph';
  const BarGraphScreen({Key? key}) : super(key: key);

  @override
  _BarGraphScreenState createState() => _BarGraphScreenState();
}

class _BarGraphScreenState extends State<BarGraphScreen> {
  BarGraphModel barGraphData =
      BarGraphModel(data: {}, title: '', labelY: '', legend: '');
  bool _disableSave = false;
  late TooltipBehavior _tooltipBehavior;

  List<Data> get _chartData {
    final List<Data> l = [];
    for (int i = 1; i <= barGraphData.data.length; i++) {
      l.add(Data(barGraphData.data[i]![0] as String,
          barGraphData.data[i]![1] as double));
    }
    return l;
  }

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    barGraphData = ModalRoute.of(context)!.settings.arguments as BarGraphModel;
    _disableSave = barGraphData.isSaved;
    final axisLineColor = Theme.of(context).appBarTheme.titleTextStyle!.color;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bar Graph'),
          leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
          actions: [
            IconButton(
              onPressed: _disableSave
                  ? null
                  : () {
                      Provider.of<GraphProvider>(context, listen: false)
                          .saveGraph(barGraphData, TypeOfGraph.BarGraph);
                      setState(() {
                        barGraphData.isSaved = true;
                      });
                    },
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: SfCartesianChart(
          title: ChartTitle(
            text: barGraphData.title!,
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
            BarSeries<Data, String>(
              name: barGraphData.legend,
              dataSource: _chartData,
              xValueMapper: (Data data, _) => data.label,
              yValueMapper: (Data data, _) => data.value,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              enableTooltip: true,
              color: Theme.of(context).primaryColor,
            ),
          ],
          primaryXAxis: CategoryAxis(
            axisLine: AxisLine(
              color: axisLineColor,
            ),
            labelStyle: TextStyle(color: axisLineColor),
          ),
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            title: AxisTitle(
              text: barGraphData.labelY,
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
