import 'dart:convert';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

import 'package:throw_away_main/main.dart';
import 'package:throw_away_main/sign_up/signup_main.dart';
import 'package:throw_away_main/log_in/login_main.dart';
import 'package:throw_away_main/shop/shop.dart';
import 'package:throw_away_main/data/login_data.dart';
import 'package:throw_away_main/data/Store_data.dart';

class ClientDrawer extends StatefulWidget {
  const ClientDrawer({Key? key}) : super(key: key);

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
  late Login _myHomePage;

  @override
  Widget build(BuildContext context) {
    if (MemberInfo.mislogin&&MemberInfo.Category=='SHOP') {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(MemberInfo.UserID),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 181, 0),
              ),
            ),
            ListTile(
              title: Text('관리'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context)=>Admin(shopAux : MemberInfo.PhoneNum))
                );
              },
            ),
            ListTile(
              title: Text('로그아웃'),
              onTap: () {
                Navigator.pop(context);
                logout();
              },
            ),
            ListTile(
              title: Text('월간 순위(5순위)'),
              onTap:(){
                Rank();
              }
              ,
            )
          ],
        ),
      );
    }
    else if(MemberInfo.mislogin&&MemberInfo.Category=='USER') {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(MemberInfo.UserID),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 181, 0),
              ),
            ),
            ListTile(
              title: Text('로그아웃'),
              onTap: () {
                Navigator.pop(context);
                logout();
              },
            )
          ],
        ),
      );
    }
    else {
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
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context)=>_myHomePage=Login(title: 'title',login_onSubmit:()=> login_onSubmit(context)))
                );
              },
            ),
            ListTile(
              title: Text('회원가입'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context)=>signUp())
                );
              },
            )
          ],
        ),
      );
    }
  }

  void login_onSubmit(BuildContext context){
    Future<bool> _future=isLogin();

    _future.then((val){
      MemberInfo.UserID=_myHomePage.userid;
      Navigator.pop(context,true);
      showToast('로그인 성공');
      MemberInfo.mislogin=true;
      runApp(const MyApp());

    }).catchError((error){
      showToast('로그인 실패');
    });
  }

  void logout() async{
    // ?REQ=api_LOGOUT
    String _UriInfo='http://52.79.202.39/?REQ=api_LOGOUT';
    final url=Uri.parse(_UriInfo);
    final response = await http.get(url);

    print('isLogin Response status: ${response.statusCode}');
    print('isLogin Response body: ${response.body}');

    MemberInfo.mislogin=false;
    MemberInfo.UserID='';
    MemberInfo.Category='';
    MemberInfo.PhoneNum='';

    showToast('로그아웃 완료');

    runApp(const MyApp());
  }

  Future<bool> isLogin() async{
    String _UriInfo='http://52.79.202.39/?REQ=api_LOGIN&USER_ID=${_myHomePage.userid}&USER_PW=${_myHomePage.userpw}';
    final url=Uri.parse(_UriInfo);
    final response = await http.get(url);

    print('isLogin Response status: ${response.statusCode}');
    print('isLogin Response body: ${response.body}');
    print('jsondecode : ${jsonDecode(response.body)}');

    Map<String,dynamic> parseInfo=jsonDecode(jsonDecode(response.body));
    MemberInfo.PhoneNum=parseInfo['ID_AUX'];
    MemberInfo.Category=parseInfo['CATEGORY'];

    print('asdfas'+MemberInfo.PhoneNum);
    print('asdfas'+MemberInfo.Category);

    // String _UriInfo2='http://52.79.202.39/?REQ=post_GET_ROOT_INFO&PHONE_NUM=01028282828&CATEGORY=SHOP';
    // final url2=Uri.parse(_UriInfo2);
    // final response2 = await http.get(url2);
    //
    // print('asdfkljsdakf: ${response2.body}');


    if(!response.body.contains('ID_MAIN')) throw 'error';

    return true;
  }

  Future<void> Rank() async{
    try {
      Location location = new Location();
      shop_ranks = [];

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }
      _locationData = await location.getLocation();

      String current_location = "";
      if (TestMode) {
        current_location =
            '''{"LNG":''' + '37.557' + ''',"LAT":''' + '126.92' + '''}''';

        currentUser.lat = 37.557;
        currentUser.lng = 126.92;
      } else {
        ///다시 살려야됨
        current_location = '''{"LNG":''' +
            _locationData.longitude.toString() +
            ''',"LAT":''' +
            _locationData.latitude.toString() +
            '''}''';

        currentUser.lat = double.parse(_locationData.latitude.toString());
        currentUser.lng = double.parse(_locationData.longitude.toString());
      }

      String rankurl =
          'http://52.79.202.39/?REQ=post_GET_SHOP_RANK&CUR_LOCATION=' +
              current_location +
              '&CATEGORY=' +
              'SHOP';
      Uri rank = Uri.parse(rankurl);

      List<U_Store> _ranks = [];
      String _text = "";
      http.Response rank_response = await http.get(rank);

      if (rank_response != null) {
        print(json.decode(rank_response.body));
        _text = utf8.decode(rank_response.bodyBytes);
        var dataObjsJson = jsonDecode(_text) as List;
        final List<U_Store> parsedResponse =
        dataObjsJson.map((dataJson) => U_Store.fromJson(dataJson)).toList();
        _ranks.clear();
        _ranks.addAll(parsedResponse);
        shop_ranks = _ranks;
        print(parsedResponse);
      } else {
        print("hi");
      }

      if(_ranks.length>0){
        DialogButton(context);
      }
    }
    catch(e){
      throw Exception("hh");
    }
  }

  void DialogButton(BuildContext context) {
    showDialog<String>(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("월간 순위표"),
              ],
            ),
            //
            content: Expanded(
              child: _Rank_List(),
            ),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  _Rank_List() {
    return ListView(padding: const EdgeInsets.all(5),children: [
      Container(
        height: 50,
        color: Colors.transparent,
        child: Center(
          child: Text(shop_ranks[0].shopName),
        ),
        // ),
      ),
      Container(
        height: 50,
        color: Colors.transparent,
        child: Center(
          child: Text(shop_ranks[1].shopName),
        ),
      ),
      Container(
        height: 50,
        color: Colors.transparent,
        child: Center(child: Text(shop_ranks[2].shopName)),
      ),
      Container(
        height: 50,
        color: Colors.transparent,
        child: Center(child: Text(shop_ranks[3].shopName)),
      ),
      Container(
        height: 50,
        color: Colors.transparent,
        child: Center(child: Text(shop_ranks[4].shopName)),
      )
    ]);
  }
}

