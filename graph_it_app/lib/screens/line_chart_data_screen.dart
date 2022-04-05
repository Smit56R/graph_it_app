import 'package:flutter/material.dart';

import './line_chart_screen.dart';

import '../models/line_chart_model.dart';

import '../widgets/app_back_button.dart';
import '../widgets/background_builder.dart';

class LineChartDataScreen extends StatelessWidget {
  static const routeName = '/line-chart-data';
  const LineChartDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BackgroundBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Fill Line Chart Data'),
            leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
          ),
          body: LineChartData(),
        ),
      ),
    );
  }
}

class LineChartData extends StatefulWidget {
  const LineChartData({Key? key}) : super(key: key);

  @override
  _LineChartDataState createState() => _LineChartDataState();
}

class _LineChartDataState extends State<LineChartData> {
  final Map<int, List<double>> points = {
    1: [0, 0],
    2: [0, 0],
  };
  String? title;
  String? labelX;
  String? labelY;
  bool isCurved = false;
  int _counter = 2;
  final _form = GlobalKey<FormState>();

  Widget cellField(
    bool isRowCell,
    int number,
  ) {
    return Container(
      width: 50,
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
            //border: OutlineInputBorder(),

            ),
        //style: TextStyle(fontStyle: FontStyle.italic),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) return 'Empty';
          if (double.tryParse(value) == null) return 'Invalid';
          return null;
        },
        onSaved: (newValue) {
          if (isRowCell)
            points[number]![0] = double.parse(newValue!);
          else
            points[number]![1] = double.parse(newValue!);
        },
      ),
    );
  }

  Widget labelInputWidget(
    String title,
    Function(String?) onSave,
  ) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Text(
          '$title: ',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Empty';
              return null;
            },
            onSaved: onSave,
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  void _saveForm() {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    print(points);
    final lineChartData = LineChartModel(
      points: points,
      title: title,
      labelX: labelX,
      labelY: labelY,
      isCurved: isCurved,
    );
    Navigator.of(context).pushNamed(
      LineChartScreen.routeName,
      arguments: lineChartData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _form,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              //padding: const EdgeInsets.all(15),
              child: DataTable(
                showBottomBorder: true,
                columns: [
                  DataColumn(
                    label: const Text('Index'),
                  ),
                  DataColumn(
                    label: const Text('X'),
                  ),
                  DataColumn(
                    label: const Text('Y'),
                  ),
                ],
                rows: List.generate(_counter, (index) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text('${index + 1}'),
                      ),
                      DataCell(cellField(true, index + 1)),
                      DataCell(cellField(false, index + 1)),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                      points.putIfAbsent(_counter, () => [0, 0]);
                    });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: _counter == 1
                      ? null
                      : () {
                          setState(() {
                            points.remove(_counter);
                            _counter--;
                          });
                        },
                  icon: Icon(
                    Icons.remove_circle,
                    size: 30,
                    color:
                        _counter <= 1 ? null : Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const Divider(),
            labelInputWidget('Title', (newValue) => title = newValue),
            const SizedBox(height: 40),
            labelInputWidget(
                'Label on X-axis', (newValue) => labelX = newValue),
            const SizedBox(height: 40),
            labelInputWidget(
                'Label on Y-axis', (newValue) => labelY = newValue),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  'Line Curve',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Switch(
                  value: isCurved,
                  onChanged: (value) {
                    setState(() {
                      isCurved = !isCurved;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveForm,
              child: const Text('Show Graph'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).canvasColor,
                onPrimary: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
