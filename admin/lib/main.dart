import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'screen/admin.dart';
import 'package:http/http.dart' as http;

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
    _loginAPI();
    // if(_myHomePage.userid==''&&_myHomePage.userpw=='') {
    //   _screen=_adminPage;
    //   setState(() {
    //   });
    // }
    // else{
    //   _screen=_myHomePage;
    //   setState(() {
    //
    //   });
    // }
  }

  void logout() {
    _screen=_myHomePage;
    setState(() {

    });
  }

  Future<void> _loginAPI() async {
    // var url=Uri.parse('http://52.79.202.39/?REQ=api_WP_USER_ADD&USER_ID=chan&USER_PW=1234&USER_TYPE=SHOP');
    // var url=Uri.parse('http://52.79.202.39/?REQ=post_PUT_ROOT_INFO&ID_MAIN=chan&CATEGORY=SHOP&JSON_UPDATE={ (json 정보) "데이터타이틀":"데이터", }');
    var url=Uri.parse('http://52.79.202.39/?REQ=api_LOGIN&USER_ID=bluehill&USER_PW=qmffnglf');
    var response=await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // sleep(const Duration(seconds: 2));
    //
    // var url2=Uri.parse('http://52.79.202.39/?REQ=api_IS_LOGIN');
    // var response2=await http.get(url2);
    // print('Response status: ${response2.statusCode}');
    // print('Response body: ${response2.body}');

    // var url3=Uri.parse('http://52.79.202.39/?REQ=post_GET_ROOT_INFO&ID_MAIN=bluehill&CATEGORY=SHOP');
    // var response3=await http.get(url3);
    // print('Response status: ${response3.statusCode}');
    // print('Response body: ${response3.body}');

    // getDeviceUniqueId();

  }

// Future<String> getDeviceUniqueId() async {
//   var deviceIdentifier = 'unknown';
//   var deviceInfo = DeviceInfoPlugin();
//
//   if (Platform.isAndroid) {
//     var androidInfo = await deviceInfo.androidInfo;
//     deviceIdentifier = androidInfo.androidId!;
//   } else if (Platform.isIOS) {
//     var iosInfo = await deviceInfo.iosInfo;
//     deviceIdentifier = iosInfo.identifierForVendor!;
//   } else if (Platform.isLinux) {
//     var linuxInfo = await deviceInfo.linuxInfo;
//     deviceIdentifier = linuxInfo.machineId!;
//   }
//
//   return deviceIdentifier;
// }

}

