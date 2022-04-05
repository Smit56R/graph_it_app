import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/google_sign_in_provider.dart';

import '../screens/saved_graphs_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/explore_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget drawerTile(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              title: const Text(
                'Simply Graph!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w400,
                ),
              ),
              backgroundColor: Colors.deepPurple[900],
              automaticallyImplyLeading: false, //No back arrow
            ),
            drawerTile(context, 'Home', Icons.home, '/'),
            const Divider(),
            drawerTile(context, 'Saved Graphs', Icons.storage,
                SavedGraphsScreen.routeName),
            const Divider(),
            drawerTile(
                context, 'Explore', Icons.explore, ExploreScreen.routeName),
            const Divider(),
            drawerTile(context, 'Profile', Icons.account_circle,
                ProfileScreen.routeName),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.headline6,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<GoogleSignInProvider>(context, listen: false)
                    .logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
