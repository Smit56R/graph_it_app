import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/pie_chart_model.dart';
import '../models/type_of_graph.dart';

import '../providers/graph_provider.dart';

import '../widgets/app_back_button.dart';

class Data {
  final String label;
  final double value;
  Data(this.label, this.value);
}

class PieChartScreen extends StatefulWidget {
  static const routeName = '/pie-chart';
  const PieChartScreen({Key? key}) : super(key: key);

  @override
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  PieChartModel pieChartData = PieChartModel(data: {}, title: '');
  bool _disableSave = false;
  late TooltipBehavior _tooltipBehavior;

  List<Data> get _chartData {
    final List<Data> l = [];
    for (int i = 1; i <= pieChartData.data.length; i++) {
      l.add(Data(pieChartData.data[i]![0] as String,
          pieChartData.data[i]![1] as double));
    }
    return l;
  }

  @override
  void initState() {
    super.initState();
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x: point.y');
  }

  @override
  Widget build(BuildContext context) {
    pieChartData = ModalRoute.of(context)!.settings.arguments as PieChartModel;
    _disableSave = pieChartData.isSaved;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pie Chart'),
          leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
          actions: [
            IconButton(
              onPressed: _disableSave
                  ? null
                  : () {
                      Provider.of<GraphProvider>(context, listen: false)
                          .saveGraph(pieChartData, TypeOfGraph.PieChart);
                      setState(() {
                        pieChartData.isSaved = true;
                      });
                    },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SfCircularChart(
          title: ChartTitle(
            text: pieChartData.title!,
            textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          tooltipBehavior: _tooltipBehavior,
          series: <CircularSeries>[
            PieSeries<Data, String>(
              dataSource: _chartData,
              xValueMapper: (Data data, _) => data.label,
              yValueMapper: (Data data, _) => data.value,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              enableTooltip: true,
              explode: true,
              dataLabelMapper: (datum, index) {
                return '${datum.value}';
              },
            )
          ],
        ),
      ),
    );
  }
}
