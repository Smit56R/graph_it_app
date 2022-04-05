import 'package:flutter/material.dart';

import '../models/multi_line_chart_model.dart';

import './multi_line_chart_screen.dart';

import '../widgets/app_back_button.dart';
import '../widgets/background_builder.dart';

class MultiLineChartDataScreen extends StatelessWidget {
  static const routeName = '/multi-line-chart-data';
  const MultiLineChartDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BackgroundBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: FittedBox(child: const Text('Fill Multi-Line Chart Data')),
            leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
          ),
          body: MultiLineChartData(),
        ),
      ),
    );
  }
}

class MultiLineChartData extends StatefulWidget {
  const MultiLineChartData({Key? key}) : super(key: key);

  @override
  _MultiLineChartDataState createState() => _MultiLineChartDataState();
}

class _MultiLineChartDataState extends State<MultiLineChartData> {
  final List<Map<int, List<double>>> points = [
    {
      1: [0, 0],
      2: [0, 0],
    },
    {
      1: [0, 0],
      2: [0, 0],
    },
  ];
  final List<String> legends = ['', ''];
  String? title;
  String? labelX;
  String? labelY;
  bool isCurved = false;
  int _counter = 2, _lineCount = 2;
  final _form = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  Widget cellField(
    bool isRowCell,
    int index,
    int number,
  ) {
    return Container(
      width: 50,
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) return 'Empty';
          if (double.tryParse(value) == null) return 'Invalid';
          return null;
        },
        onSaved: (newValue) {
          if (isRowCell)
            points[index][number]![0] = double.parse(newValue!);
          else
            points[index][number]![1] = double.parse(newValue!);
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
    final multiLineChartData = MultiLineChartModel(
      multiPoints: points,
      legends: legends,
      title: title,
      labelX: labelX,
      labelY: labelY,
      isCurved: isCurved,
    );
    Navigator.of(context).pushNamed(
      MultiLineChartScreen.routeName,
      arguments: multiLineChartData,
    );
  }

  List<DataColumn> get columnList {
    final List<DataColumn> L = [];
    for (int i = 0; i < _lineCount; i++) {
      L.add(
        DataColumn(
          label: Text('X${i + 1}'),
        ),
      );
      L.add(
        DataColumn(
          label: Text('Y${i + 1}'),
        ),
      );
    }
    return L;
  }

  List<Widget> get legendList {
    final List<Widget> L = [];
    for (int i = 0; i < _lineCount; i++) {
      L.add(labelInputWidget(
          'Legend ${i + 1}', (newValue) => legends[i] = newValue!));
      L.add(const SizedBox(height: 40));
    }
    return L;
  }

  List<DataCell> cellList(int index) {
    final List<DataCell> L = [];
    for (int i = 0; i < _lineCount; i++) {
      L.add(DataCell(cellField(true, i, index + 1)));
      L.add(DataCell(cellField(false, i, index + 1)));
    }
    return L;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _form,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _lineCount++;
                      final Map<int, List<double>> map = {};
                      for (int i = 1; i <= _counter; i++) {
                        map.putIfAbsent(i, () => [0, 0]);
                      }
                      points.add(map);
                      legends.add('');
                    });
                  },
                  child: const Text('Add Line'),
                ),
                TextButton(
                  onPressed: _lineCount == 2
                      ? null
                      : () {
                          setState(() {
                            points.removeAt(_lineCount - 1);
                            _lineCount--;
                          });
                        },
                  child: const Text('Remove Line'),
                ),
                const SizedBox(width: 5),
              ],
            ),
            Container(
              width: double.infinity,
              child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showBottomBorder: true,
                    columns: [
                      DataColumn(
                        label: const Text('Index'),
                      ),
                      ...columnList
                    ],
                    rows: List.generate(_counter, (index) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text('${index + 1}'),
                          ),
                          ...cellList(index)
                        ],
                      );
                    }),
                  ),
                ),
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
                      for (int i = 0; i < _lineCount; i++) {
                        points[i].putIfAbsent(_counter, () => [0, 0]);
                      }
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
                            for (int i = 0; i < _lineCount; i++) {
                              points[i].remove(_counter);
                            }
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
            ...legendList,
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
