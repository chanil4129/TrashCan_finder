import 'dart:math';

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
              child: Text('회원정보'),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 181, 0),
              ),
            ),
            ListTile(
              title: Text('bluehill'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context)=>Admin())
                );
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
      Navigator.pop(context,true);
      showToast('로그인 성공');
      MemberInfo.mislogin=true;
      runApp(const MyApp());

    }).catchError((error){
      showToast('로그인 실패');
    });
  }

  void logout() {
    setState(() {

    });
  }

  Future<bool> isLogin() async{
    String _UriInfo='http://52.79.202.39/?REQ=api_LOGIN&USER_ID=${_myHomePage.userid}&USER_PW=${_myHomePage.userpw}';
    print(_UriInfo);
    final url=Uri.parse(_UriInfo);
    final response = await http.get(url);

    print('isLogin Response status: ${response.statusCode}');
    print('isLogin Response body: ${response.body}');

    if(!response.body.contains('ID_MAIN')) throw 'error';

    return true;
  }

  // void loginInfo() async{
  //   // String _UriInfo='http://52.79.202.39/?REQ=api_LOGIN&USER_ID=${_myHomePage.userid}&USER_PW=${_myHomePage.userpw}';
  // }
}
