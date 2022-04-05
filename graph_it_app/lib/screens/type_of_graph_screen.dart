import 'package:flutter/material.dart';

import './line_chart_data_screen.dart';
import './pie_chart_data_screen.dart';
import './bar_graph_data_screen.dart';
import './multi_line_chart_data_screen.dart';

import '../widgets/app_back_button.dart';
import '../widgets/background_builder.dart';

import '../models/type_of_graph.dart';

class TypeOfGraphScreen extends StatelessWidget {
  static const routeName = '/type-of-graph';
  TypeOfGraphScreen({Key? key}) : super(key: key);

  Widget graphCard(
    BuildContext context,
    String title,
    String routeName,
    IconData icon,
    TypeOfGraph type,
  ) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            color: Theme.of(context).canvasColor,
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Color.fromRGBO(67, 44, 129, 1),
                  size: 40,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
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
          title: const Text('Select Type Of Graph'),
          leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
            ),
            children: [
              graphCard(
                context,
                'Line Chart',
                LineChartDataScreen.routeName,
                Icons.show_chart,
                TypeOfGraph.LineChart,
              ),
              graphCard(
                context,
                'Pie Chart',
                PieChartDataScreen.routeName,
                Icons.pie_chart,
                TypeOfGraph.PieChart,
              ),
              graphCard(
                context,
                'Bar Graph',
                BarGraphDataScreen.routeName,
                Icons.bar_chart,
                TypeOfGraph.BarGraph,
              ),
              graphCard(
                context,
                'Multi-Line Chart',
                MultiLineChartDataScreen.routeName,
                Icons.stacked_line_chart,
                TypeOfGraph.LineChart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
