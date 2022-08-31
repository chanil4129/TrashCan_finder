import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'screen/admin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Widget _screen;
  late MyHomePage _myHomePage;
  late AdminPage _adminPage;

  MyAppState(){
    _myHomePage = new MyHomePage(title: 'Flutter Demo Home Page',onSubmit: onSubmit,);
    _adminPage = new AdminPage(logout: logout,);
    _screen=_myHomePage;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: _screen,
    );;
  }

  void onSubmit() {
    if(_myHomePage.userid==''&&_myHomePage.userpw=='') {
      _screen=_adminPage;
      setState(() {
      });
    }
    else{
      _screen=_myHomePage;
      setState(() {

      });
    }
  }

  void logout() {
    _screen=_myHomePage;
    setState(() {

    });
  }
}

