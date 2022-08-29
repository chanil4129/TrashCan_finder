import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedDestination = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('TrashCan_finder'),
          actions: [
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Header',
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Item 1'),
                selected: _selectedDestination == 0,
                onTap: () => selectDestination(0),
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Item 2'),
                selected: _selectedDestination == 1,
                onTap: () => selectDestination(1),
              ),
              ListTile(
                leading: Icon(Icons.label),
                title: Text('Item 3'),
                selected: _selectedDestination == 2,
                onTap: () => selectDestination(2),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Label',
                ),
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Item A'),
                selected: _selectedDestination == 3,
                onTap: () => selectDestination(3),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              child: GarbageChips(),
            ),
            Expanded(child: NaverMapTest())
          ],
        ),
        bottomNavigationBar: Text("bottom"),
      ),
    );
  }
  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPermission();
  }
}

class GarbageChips extends StatefulWidget {
  const GarbageChips({Key? key}) : super(key: key);

  @override
  State<GarbageChips> createState() => _GarbageChipsState();
}

class _GarbageChipsState extends State<GarbageChips> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            color: Colors.black26,
            height: 50,
            child: Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('일반쓰레기'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('플라스틱'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('페트병'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('캔'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('병'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('병'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('병'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('병'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InputChip(
                          avatar: Icon(Icons.remove),
                          label: Text('병'),
                          onSelected: (bool value) {},
                        ),
                      ),

                    ],
                  ),
                )
            )
        ),
      ),
    );
  }
}

class NaverMapTest extends StatefulWidget {
  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}

class _NaverMapTestState extends State<NaverMapTest> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NaverMap(
          onMapCreated: onMapCreated,
          mapType: _mapType,
        ),
      ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}


getPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.location,
  ].request();
}
