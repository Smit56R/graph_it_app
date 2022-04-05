import 'package:flutter/material.dart';

import '../models/bar_graph_model.dart';

import './bar_graph_screen.dart';

import '../widgets/app_back_button.dart';
import '../widgets/background_builder.dart';

class BarGraphDataScreen extends StatelessWidget {
  static const routeName = '/bar-graph-data';
  const BarGraphDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BackgroundBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Bar Graph'),
            leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
          ),
          body: BarGraphData(),
        ),
      ),
    );
  }
}

class BarGraphData extends StatefulWidget {
  const BarGraphData({Key? key}) : super(key: key);

  @override
  _BarGraphDataState createState() => _BarGraphDataState();
}

class _BarGraphDataState extends State<BarGraphData> {
  final Map<int, List<Object>> dataValues = {
    1: ['', 0],
    2: ['', 0],
  };
  String? title, labelY, legend;
  int _counter = 2;
  final _form = GlobalKey<FormState>();

  Widget cellField(
    bool isLabelCell,
    int number,
  ) {
    return Container(
      width: isLabelCell ? 100 : 50,
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
            //border: OutlineInputBorder(),

            ),
        //style: TextStyle(fontStyle: FontStyle.italic),
        keyboardType: isLabelCell ? null : TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) return 'Empty';
          if (!isLabelCell &&
              (double.tryParse(value) == null || double.parse(value) < 0))
            return 'Invalid';
          return null;
        },
        onSaved: (newValue) {
          if (isLabelCell)
            dataValues[number]![0] = newValue!;
          else
            dataValues[number]![1] = double.parse(newValue!);
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
    final barGraphData = BarGraphModel(
      data: dataValues,
      title: title,
      labelY: labelY,
      legend: legend,
    );
    Navigator.of(context)
        .pushNamed(BarGraphScreen.routeName, arguments: barGraphData);
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
                    label: const Text('Label'),
                  ),
                  DataColumn(
                    label: FittedBox(
                      child: const Text('Value'),
                    ),
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
                      dataValues.putIfAbsent(_counter, () => ['', 0]);
                    });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: _counter <= 1
                      ? null
                      : () {
                          setState(() {
                            dataValues.remove(_counter);
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
                SizedBox(width: 5),
              ],
            ),
            const Divider(),
            labelInputWidget('Title', (newValue) => title = newValue),
            const SizedBox(height: 40),
            const Divider(),
            labelInputWidget('Y-Axis Title', (newValue) => labelY = newValue),
            const SizedBox(height: 40),
            const Divider(),
            labelInputWidget('Legend', (newValue) => legend = newValue),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveForm,
              child: Text('Show Graph'),
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
