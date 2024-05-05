import 'package:flutter/material.dart';
import 'package:project_uts/nav_bar.dart';
import 'package:project_uts/login_screen.dart';
import 'package:project_uts/splash_screen.dart';

class ButtonGlobal extends StatelessWidget {
  const ButtonGlobal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavBar()),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 365,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 41, 83, 154),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          'Masuk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
