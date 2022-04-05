import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './polynomial_chart_screen.dart';
import 'package:graph_it_app/widgets/app_back_button.dart';
import 'package:graph_it_app/widgets/background_builder.dart';

class PolynomialScreen extends StatefulWidget {
  static const routeName = '/polynomial-screen';
  const PolynomialScreen({Key? key}) : super(key: key);

  @override
  _PolynomialScreenState createState() => _PolynomialScreenState();
}

class _PolynomialScreenState extends State<PolynomialScreen> {
  TextEditingController controller = TextEditingController();
  bool _showInput = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void errorBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Polynomial functions'),
          leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Degree of polynomial',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      errorBar('Empty Field!');
                      return;
                    }
                    if (double.tryParse(controller.text) == null ||
                        double.parse(controller.text) < 0) {
                      errorBar('Invalid Input!');
                      return;
                    }
                    setState(() {
                      _showInput = true;
                    });
                  },
                  child: const Text("Proceed"),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).canvasColor,
                    onPrimary: Theme.of(context).primaryColor,
                  ),
                ),
                const Divider(),
                if (_showInput) InputBox(int.parse(controller.text)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  final List<TextEditingController> _controllers = [];
  final int count;
  InputBox(this.count);

  final _scrollController = ScrollController();

  void addC(int count) {
    for (int i = 0; i < count + 1; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void errorBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    addC(count);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _controllers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'a${count - index}',
                          ),
                          keyboardType: TextInputType.number,
                          controller: _controllers[index],
                        ),
                        trailing: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              'x',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              (count - index).toString(),
                              style: TextStyle(
                                fontFeatures: [
                                  FontFeature.superscripts(),
                                ],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                bool _isEmpty = false, _isValid = true;
                for (int i = 0; i < _controllers.length; i++) {
                  if (_controllers[i].text.isEmpty) {
                    _isEmpty = true;
                    break;
                  }
                  if (double.tryParse(_controllers[i].text) == null) {
                    _isValid = false;
                    break;
                  }
                }
                if (_isEmpty) {
                  errorBar(context, 'Empty Field!');
                  return;
                }
                if (!_isValid) {
                  errorBar(context, 'Invalid Input!');
                  return;
                }
                final list =
                    _controllers.map((e) => int.parse(e.text)).toList();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PolynomialChartScreen(list, -5, 5)));
              },
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
