import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _UserMainScreen();
}


class _UserMainScreen extends State<MyApp>{
  @override
  Widget build(BuildContext context){
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
        body: Column(
          children: [
            // Container(
            //   width: double.infinity,
            //   height: 40,
            //   child: Category(),
            //   color: Colors.white,
            // ),
            Expanded(child: NaverMap_User())
          ],
        ),
        drawer: Login(),
      ),
    );
  }
}


class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  final bool login = false;

  @override
  Widget build(BuildContext context){
    if(login){
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
              onTap: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
    else{
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
              onTap: (){
                ProgramAccessLogin();
              },
            ),
            ListTile(
              title: Text('회원가입'),
              onTap: (){
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
          // initialCameraPosition: CameraPosition(
          //   target: LatLng(27.6602292, 85.308027),
          //   zoom: 17,
          // ),
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

  Future<void> onLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    _locationData = await location.getLocation();
  }
}


// getPermission() async {
//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.location,
//   ].request();
// }

Future<void> ProgramAccessLogin() async{
  String geturl = 'http://52.79.202.39/?REQ=api_LOGIN&USER_ID='+'bluehill'+'&USER_PW='+'qmffnglf'+'&USER_TYPE='+'SHOP';
  Uri  url = Uri.parse(geturl);

  http.Response response = await http.get(url);
  // http.Response response = await http.post(
  //   url,
  //   headers: <String,String>{
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //   },
  //   body: <String,String>{
  //     'USER_ID': 'bluehill',
  //     'USER_PW': 'qmffnglf',
  //     'USER_TYPE': 'SHOP'
  //   }
  // );
  if(response != null){
    print(response);
  }
  else{
    print("hi");
  }
}

void ProgramAccessSign(){

}