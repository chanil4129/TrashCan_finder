import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:throw_away_main/sign_up/signup_main.dart';
import 'package:throw_away_main/log_in/login_main.dart';
import 'package:throw_away_main/shop/shop.dart';

class ClientDrawer extends StatefulWidget {
  const ClientDrawer({Key? key}) : super(key: key);

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
  bool login = false;
  late Login _myHomePage;
  late Admin _adminPage;

  _ClientDrawerState(){
    _myHomePage = new Login(title: 'title',login_onSubmit: login_onSubmit);
    _adminPage = new Admin();
  }

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
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context)=>_adminPage)
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
                    CupertinoPageRoute(builder: (context)=>_myHomePage)
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

  void login_onSubmit(){
    if(_myHomePage.userid==''&&_myHomePage.userpw=='') {
      login=true;
      setState(() {
      });
    }
    else{
      login=false;
      setState(() {

      });
    }
  }

  void logout() {
    setState(() {

    });
  }
}
