import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './type_of_graph_screen.dart';
import './file_upload_screen.dart';
import './profile_screen.dart';
import './math functions/polynomial_screen.dart';

import '../widgets/app_drawer.dart';

import '../widgets/background_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget applicationCard(
    BuildContext context,
    String title,
    String routeName,
    IconData icon,
  ) {
    final mediaQuery = MediaQuery.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: mediaQuery.size.height *
            (mediaQuery.orientation == Orientation.portrait ? 0.15 : 0.25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            color: Theme.of(context).canvasColor,
            elevation: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: Color.fromRGBO(67, 44, 129, 1),
                  size: 40,
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
    final user = FirebaseAuth.instance.currentUser!;
    return BackgroundBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Hi ${user.displayName}!'),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.view_headline,
                size: 40,
              ),
            ),
          ),
          actions: [
            Hero(
              tag: '#user_profile',
              child: InkWell(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 23,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ProfileScreen.routeName);
                },
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        drawer: const AppDrawer(),
        body: ListView(
          children: [
            const SizedBox(height: 50),
            applicationCard(
              context,
              'ENTER FUNCTION',
              PolynomialScreen.routeName,
              Icons.functions,
            ),
            const SizedBox(height: 20),
            applicationCard(
              context,
              'UPLOAD A FILE',
              FileUploadScreen.routeName,
              Icons.insert_drive_file,
            ),
            const SizedBox(height: 20),
            applicationCard(
              context,
              'TYPE IN DATA',
              TypeOfGraphScreen.routeName,
              Icons.border_color,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
