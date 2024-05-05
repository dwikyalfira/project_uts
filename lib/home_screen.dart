import 'package:flutter/material.dart';
import 'package:project_uts/widget/button.login.dart';
import 'package:project_uts/widget/buttton.register.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              './lib/assets/logo.png',
              height: 305,
              width: 305,
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            ButtonRegister(),
            SizedBox(height: 22),
            ButtonLogin(),
          ],
        ),
      ),
    );
  }
}
