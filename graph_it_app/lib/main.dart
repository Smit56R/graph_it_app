import 'package:flutter/material.dart';
import 'package:graph_it_app/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/type_of_graph_screen.dart';
import './screens/line_chart_data_screen.dart';
import './screens/line_chart_screen.dart';
import './screens/saved_graphs_screen.dart';
import './screens/pie_chart_screen.dart';
import './screens/pie_chart_data_screen.dart';
import './screens/bar_graph_screen.dart';
import './screens/bar_graph_data_screen.dart';
import './screens/multi_line_chart_screen.dart';
import './screens/multi_line_chart_data_screen.dart';
import './screens/file_upload_screen.dart';
import './screens/profile_screen.dart';
import './screens/explore_screen.dart';
import './screens/math functions/polynomial_screen.dart';

import './providers/graph_provider.dart';
import './providers/google_sign_in_provider.dart';

import './models/type_of_graph.dart';
import './models/line_chart_model.dart';
import './models/pie_chart_model.dart';
import './models/bar_graph_model.dart';
import './models/multi_line_chart_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(TypeOfGraphAdapter());
  Hive.registerAdapter(LineChartModelAdapter());
  Hive.registerAdapter(PieChartModelAdapter());
  Hive.registerAdapter(BarGraphModelAdapter());
  Hive.registerAdapter(GraphItemAdapter());
  Hive.registerAdapter(MultiLineChartModelAdapter());
  await Hive.openBox<GraphItem>('graphs');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GraphProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Simply Graph',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Color.fromRGBO(67, 44, 129, 1),
          accentColor:
              Color.fromRGBO(73, 27, 77, 1), //Color.fromRGBO(50, 30, 103, 1),
          canvasColor: Color.fromRGBO(237, 236, 244, 1),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Rubik',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                color: Color.fromRGBO(67, 44, 129, 1),
              ),
              button: TextStyle(
                color: Color.fromRGBO(67, 44, 129, 1),
              )),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 30,
              color: Color.fromRGBO(73, 27, 77, 1),
              //fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Color.fromRGBO(67, 44, 129, 1),
              size: 40,
            ),
          ),
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        ),
        home: SignInScreen(),
        routes: {
          TypeOfGraphScreen.routeName: (_) => TypeOfGraphScreen(),
          SavedGraphsScreen.routeName: (_) => SavedGraphsScreen(),
          LineChartDataScreen.routeName: (_) => LineChartDataScreen(),
          LineChartScreen.routeName: (_) => LineChartScreen(),
          PieChartScreen.routeName: (_) => PieChartScreen(),
          PieChartDataScreen.routeName: (_) => PieChartDataScreen(),
          BarGraphScreen.routeName: (_) => BarGraphScreen(),
          BarGraphDataScreen.routeName: (_) => BarGraphDataScreen(),
          MultiLineChartDataScreen.routeName: (_) => MultiLineChartDataScreen(),
          MultiLineChartScreen.routeName: (_) => MultiLineChartScreen(),
          FileUploadScreen.routeName: (_) => FileUploadScreen(),
          ProfileScreen.routeName: (_) => ProfileScreen(),
          ExploreScreen.routeName: (_) => ExploreScreen(),
          PolynomialScreen.routeName: (_) => PolynomialScreen(),
        },
      ),
    );
  }
}
