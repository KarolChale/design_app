import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:design_app/src/pages/home_page.dart';
import 'package:design_app/src/pages/login_page.dart';
import 'package:design_app/src/pages/menu_pages/todo_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Design',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => Login(),
        'home': (BuildContext context) => Home(),
        'todo': (BuildContext context) => Todo(),
      },
    );
  }
}
