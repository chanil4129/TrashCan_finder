import 'dart:convert';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:throw_away_main/main.dart';
import 'package:throw_away_main/sign_up/signup_main.dart';
import 'package:throw_away_main/log_in/login_main.dart';
import 'package:throw_away_main/shop/shop.dart';
import 'package:throw_away_main/data/login_data.dart';

class ClientDrawer extends StatefulWidget {
  const ClientDrawer({Key? key}) : super(key: key);

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
  late Login _myHomePage;

  @override
  Widget build(BuildContext context) {
    if (MemberInfo.mislogin) {
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
                    CupertinoPageRoute(builder: (context)=>Admin())
                );
              },
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


    if(!response.body.contains('ID_MAIN')) throw 'error';

    return true;
  }

}

