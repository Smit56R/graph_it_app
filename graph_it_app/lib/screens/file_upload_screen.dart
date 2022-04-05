import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

import './pie_chart_screen.dart';
import './line_chart_screen.dart';
import './bar_graph_screen.dart';

import '../models/type_of_graph.dart';
import '../models/pie_chart_model.dart';
import '../models/line_chart_model.dart';
import '../models/bar_graph_model.dart';

import '../widgets/app_back_button.dart';
import '../widgets/background_builder.dart';

enum FileExtension {
  CSV,
  JSON,
}

class FileUploadScreen extends StatefulWidget {
  static const routeName = '/file-upload';
  @override
  _FileUploadScreen createState() => _FileUploadScreen();
}

class _FileUploadScreen extends State<FileUploadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TypeOfGraph _graphType = TypeOfGraph.LineChart;
  FileExtension _fileType = FileExtension.JSON;
  late String fileName;
  late dynamic _chart;
  bool _dataAvailable = false;
  late Size deviceSize;

  void errorSnackBar(String message) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          if (_dataAvailable) _dataAvailable = false;
        });
      },
    );
  }

  Future<void> resolveData(dynamic data) async {
    try {
      var dataValues;
      var x, y;
      int i = 0, key = 1;
      if (_fileType == FileExtension.JSON) {
        dataValues = data['data'] as List<dynamic>;
        x = 'x';
        y = 'y';
      } else {
        dataValues = data as List<List<dynamic>>;
        //print(dataValues);
        x = 0;
        y = 1;
      }
      switch (_graphType) {
        case TypeOfGraph.LineChart:
          if (_fileType == FileExtension.CSV) i = 3;
          final Map<int, List<double>> points = {};
          for (; i < dataValues.length; i++, key++) {
            points[key] = [
              // double.parse(dataValues[i]['x']),
              // double.parse(dataValues[i]['y']),
              dataValues[i][x] is int
                  ? (dataValues[i][x] as int).toDouble()
                  : dataValues[i][x],
              dataValues[i][y] is int
                  ? (dataValues[i][y] as int).toDouble()
                  : dataValues[i][y],
            ];
          }
          _chart = LineChartModel(
            points: points,
            title: _fileType == FileExtension.JSON
                ? data['title']
                : dataValues[1][1],
            labelX: _fileType == FileExtension.JSON
                ? data['labelX']
                : dataValues[2][0],
            labelY: _fileType == FileExtension.JSON
                ? data['labelY']
                : dataValues[2][1],
            isCurved: _fileType == FileExtension.JSON
                ? (data['isCurved'] == "true" ? true : false)
                : (dataValues[0][1] == "TRUE" ? true : false),
          );
          break;
        case TypeOfGraph.PieChart:
          if (_fileType == FileExtension.CSV) i = 2;
          final Map<int, List<Object>> points = {};
          for (; i < dataValues.length; i++, key++) {
            points[key] = [
              dataValues[i][x],
              dataValues[i][y] is String
                  ? double.parse(dataValues[i][y])
                  : (dataValues[i][y] is int
                      ? (dataValues[i][y] as int).toDouble()
                      : dataValues[i][y]),
            ];
          }
          _chart = PieChartModel(
              data: points,
              title: _fileType == FileExtension.JSON
                  ? data['title']
                  : dataValues[0][1]);
          break;
        case TypeOfGraph.BarGraph:
          if (_fileType == FileExtension.CSV) {
            if (dataValues[0][0] != 'Legend') throw 'Invalid data!';
            i = 3;
          }
          final Map<int, List<Object>> points = {};
          for (; i < dataValues.length; i++, key++) {
            points[key] = [
              dataValues[i][x] is String
                  ? dataValues[i][x]
                  : dataValues[i][x].toString(),
              dataValues[i][y] is int
                  ? (dataValues[i][y] as int).toDouble()
                  : dataValues[i][y],
            ];
          }
          _chart = BarGraphModel(
            data: points,
            labelY: _fileType == FileExtension.JSON
                ? data['labelY']
                : dataValues[2][1],
            legend: _fileType == FileExtension.JSON
                ? data['legend']
                : dataValues[0][1],
            title: _fileType == FileExtension.JSON
                ? data['title']
                : dataValues[1][1],
          );
          break;
        case TypeOfGraph.MultiLineChart:
          break;
      }
    } catch (e) {
      errorSnackBar('Follow the file format!');
      print(e);
    }
  }

  Future<void> readJson(File file) async {
    try {
      final String response = await file.readAsString();
      final data = await json.decode(response)['chart'];
      switch (data['type']) {
        case 'line':
          if (_graphType != TypeOfGraph.LineChart) throw 'type error';
          break;
        case 'pie':
          if (_graphType != TypeOfGraph.PieChart) throw 'type error';
          break;
        case 'bar':
          if (_graphType != TypeOfGraph.BarGraph) throw 'type error';
          break;
      }
      await resolveData(data);
      setState(() => _dataAvailable = true);
    } catch (e) {
      if (e != 'type error')
        errorSnackBar('Follow the file format');
      else
        errorSnackBar('Select correct chart type!');
    }
  }

  Future<void> readCsv(File file) async {
    final _rawData = await file.readAsString();
    List<List<dynamic>> _listData = CsvToListConverter().convert(_rawData);
    await resolveData(_listData);
    setState(() => _dataAvailable = true);
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        if (!((_fileType == FileExtension.JSON && file.path.endsWith('json')) ||
            (_fileType == FileExtension.CSV && file.path.endsWith('csv')))) {
          errorSnackBar('Select correct file type!');
          return;
        }
        int idx = file.path.indexOf('/file_picker/');
        fileName = file.path.substring(idx + 13);
        if (_fileType == FileExtension.JSON)
          readJson(file);
        else {
          readCsv(file);
        }
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
      errorSnackBar('Something went wrong!');
    } catch (ex) {
      print(ex);
      errorSnackBar('Something went wrong!');
    }
    if (!mounted) return;
  }

  Widget buttonTemplate(
      String title, void Function()? function, bool canPress) {
    return ElevatedButton(
      onPressed: canPress ? function : null,
      child: FittedBox(
        child: new Text(
          title,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).canvasColor,
        onPrimary: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget fileFieldContainer(
    String text,
  ) {
    return Expanded(
      child: Container(
        height: 60,
        color: Colors.deepPurple[100],
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  String get previewImage {
    switch (_graphType) {
      case TypeOfGraph.LineChart:
        if (_fileType == FileExtension.JSON)
          return 'line_chart_json_format.png';
        else
          return 'line_chart_csv_format.png';
      case TypeOfGraph.PieChart:
        if (_fileType == FileExtension.JSON)
          return 'pie_chart_json_format.png';
        else
          return 'pie_chart_csv_format.png';
      case TypeOfGraph.BarGraph:
        if (_fileType == FileExtension.JSON)
          return 'bar_chart_json_format.png';
        else
          return 'bar_chart_csv_format.png';
      case TypeOfGraph.MultiLineChart:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return BackgroundBuilder(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: const Text('Upload a file'),
            leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          elevation: 6,
                          value: _graphType,
                          onChanged: (TypeOfGraph? value) {
                            setState(() {
                              if (_graphType != value) _dataAvailable = false;
                              _graphType = value!;
                            });
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                          items: [
                            DropdownMenuItem(
                              child: FittedBox(child: const Text('Line Chart')),
                              value: TypeOfGraph.LineChart,
                            ),
                            DropdownMenuItem(
                              child: FittedBox(child: const Text('Pie Chart')),
                              value: TypeOfGraph.PieChart,
                            ),
                            DropdownMenuItem(
                              child: FittedBox(child: const Text('Bar Graph')),
                              value: TypeOfGraph.BarGraph,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          elevation: 6,
                          value: _fileType,
                          onChanged: (FileExtension? value) {
                            setState(() {
                              if (_fileType != value) _dataAvailable = false;
                              _fileType = value!;
                            });
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                          items: [
                            DropdownMenuItem(
                              child: FittedBox(child: const Text('csv')),
                              value: FileExtension.CSV,
                            ),
                            DropdownMenuItem(
                              child: FittedBox(child: const Text('json')),
                              value: FileExtension.JSON,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: buttonTemplate(
                          'Choose a file', _openFileExplorer, true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                        ),
                        child: Icon(
                          Icons.insert_drive_file,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                      ),
                      fileFieldContainer(
                          _dataAvailable ? fileName : 'No file selected'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    color: Theme.of(context).primaryColor,
                    child: const Text(
                      'File Format',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: 505,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      color: Colors.white,
                    ),
                    child: Image.asset('assets/images/$previewImage'),
                  ),
                ),
                const SizedBox(height: 20),
                buttonTemplate(
                  'Show Graph',
                  () {
                    String routeName = '/';
                    switch (_graphType) {
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
                        return;
                    }
                    Navigator.of(context)
                        .pushNamed(routeName, arguments: _chart);
                  },
                  _dataAvailable,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
