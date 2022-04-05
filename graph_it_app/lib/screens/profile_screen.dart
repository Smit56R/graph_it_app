import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/app_drawer.dart';
import '../top_clip_painter.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  Widget profileTile(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).accentColor,
          ),
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomPaint(
          foregroundPainter: TopClipPainter(),
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            color: Theme.of(context).canvasColor,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(
                  Icons.view_headline,
                  size: 40,
                ),
              ),
            ),
          ),
          drawer: const AppDrawer(),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '${user.displayName!.toUpperCase()}',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Hero(
                    tag: '#user_profile',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                        radius: 55.5,
                        backgroundImage: NetworkImage(user.photoURL!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  profileTile(context, '${user.displayName!}',
                      Icons.person_outline_rounded),
                  const SizedBox(height: 8),
                  profileTile(
                      context, '${user.email!}', Icons.mail_outline_rounded),
                  const SizedBox(height: 8),
                  if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                    profileTile(context, '${user.phoneNumber!}',
                        Icons.smartphone_rounded),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
