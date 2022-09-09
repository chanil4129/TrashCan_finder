import 'package:flutter/material.dart';
import 'Drawer/drawer_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Throw_away',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Throw_away'),
      ),
      body: Stack(
        children: [
          Positioned(child: Container()/*NaverMap_User()*/),
          Container(
            width: double.infinity,
            height: 40,
            child: Container()/*Category()*/,
            color: Colors.transparent,
          )
        ],
      ),
      drawer: ClientDrawer(),
    );
  }
}
