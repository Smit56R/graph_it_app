import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../utilities/sensitive_data.dart';

class GoogleSignInProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user {
    return _user!;
  }

  Future<bool> isRegistered(String userGoogleID) async {
    final url = Uri.parse(databaseURL);
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final googleIDs = json.decode(response.body) as List<dynamic>;
      for (String id in googleIDs) {
        if (id == userGoogleID) return true;
      }
      return false;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn(); //Shows pop-up
      if (googleUser == null) return false;
      _user = googleUser;
      bool found = await isRegistered(_user!.id);
      if (!found) {
        return false;
      }
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return true;
  }

  Future logout() async {
    try {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
      //_user = null;
    } catch (e) {
      print(e);
    }
    //notifyListeners();
  }
}
