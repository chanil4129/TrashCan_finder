import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

UserLocation userLocation = UserLocation();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _UserMainScreen();
}

class _UserMainScreen extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 248, 181, 0),
          title: Center(
            child: Text("쓰레기 분리수거 찾기"),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              child: NaverMap_User()
            ),
            Container(
              width: double.infinity,
              height: 40,
              child: Category(),
              color: Colors.transparent,
            )
          ],
        ),
        drawer: Login(),
      ),
    );
  }
}

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<Category> {
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            height: 40,
            child: Container(
                margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset(
                              'myasset/myimage/general_waste.png'),
                          label: Text('일반쓰레기'),
                          backgroundColor: Colors.white,
                          onPressed: () => ProgramAccessShopData,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar:
                              new Image.asset('myasset/myimage/plastic.png'),
                          label: Text('플라스틱'),
                          backgroundColor: Colors.white,
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset('myasset/myimage/can.png'),
                          label: Text('캔'),
                          backgroundColor: Colors.white,
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset(
                              'myasset/myimage/glass_bottle.png'),
                          label: Text('병'),
                          backgroundColor: Colors.white,
                          onSelected: (bool value) {},
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final bool login = false;

  @override
  Widget build(BuildContext context) {
    if (login) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('고객 이름'),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 181, 0),
              ),
            ),
            ListTile(
              title: Text('고객 정보'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('로그인'),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 181, 0),
              ),
            ),
            ListTile(
              title: Text('로그인'),
              onTap: () {
                ProgramAccessShopData();
              },
            ),
            ListTile(
              title: Text('회원가입'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }
}

class NaverMap_User extends StatefulWidget {
  @override
  _NaverMapUserState createState() => _NaverMapUserState();
}

class _NaverMapUserState extends State<NaverMap_User> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NaverMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.5562611, 126.9239317),
            zoom: 17,
          ),
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

class UserLocation{
  double lat = 0.0;
  double lng = 0.0;
}

Future<void> ProgramAccessShopData() async{
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();

  String current_location = '''{"LNG":''' + _locationData.longitude.toString() + ''',"LAT":''' + _locationData.latitude.toString() +'''}''';

  String geturl = 'http://52.79.202.39/?REQ=post_GET_NEAR_SHOP&CUR_LOCATION=' + current_location +
  '&CATEGORY=' + 'SHOP';
  Uri url = Uri.parse(geturl);

  http.Response response = await http.get(url);
  if (response != null) {
    print(json.decode(response.body));
  } else {
    print("hi");
  }
}

Future<void> ProgramAccessLogin() async {
  String geturl = 'http://52.79.202.39/?REQ=api_LOGIN&USER_ID=' +
      'bluehill' +
      '&USER_PW=' +
      'qmffnglf' +
      '&USER_TYPE=' +
      'SHOP';
  Uri url = Uri.parse(geturl);

  http.Response response = await http.get(url);
  if (response != null) {
    print(response.body);
  } else {
    print("hi");
  }
}

void ProgramAccessSign() {}
