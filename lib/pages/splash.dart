import 'package:flutter/material.dart';
import 'package:wgoq_app/pages/tabs.dart';

class SplashScreen extends StatelessWidget {
  void loadTabsScreen(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      print('1 seconds over');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TabsPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    loadTabsScreen(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/wgoq_logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
