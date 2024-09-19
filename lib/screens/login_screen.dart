import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:googleapis_auth/src/auth_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempo_fy/callbacks/get_user.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/custom_auth.dart';
import 'package:tempo_fy/models/search.dart';
import 'package:tempo_fy/screens/nav_screen.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:tempo_fy/screens/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    login();
  }

  Future<void> login() async {
    UserController.googleSignIn.onCurrentUserChanged.listen((account) async {
      setState(() {
        currentUser = account!;
      });

      if (currentUser != null) {
        httpClient = (await UserController.googleSignIn.authenticatedClient())!;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ));
      }
    });
    UserController.googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          children: [
            const Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Image.asset('assets/icon_light.png', fit: BoxFit.contain),
            ),
            const Spacer(),
            Text(
              'Your Favorite Music from Youtube',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                'With the Tempofy music app you can get access to millions of songs, including your favorites',
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () async {
                try {
                  UserController.loginWithGoogle();
                } catch (e) {
                  print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text('Continue with Google'),
            ),
            // const Spacer(),
          ],
        )),
      ),
    );
  }
}
