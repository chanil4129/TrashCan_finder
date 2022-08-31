import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screen/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

getPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.location,
  ].request();
}
