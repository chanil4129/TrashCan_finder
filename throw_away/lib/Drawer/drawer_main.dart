import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:throw_away_main/sign_up/signup_main.dart';

class ClientDrawer extends StatefulWidget {
  const ClientDrawer({Key? key}) : super(key: key);

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
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
                // ProgramAccessShopData();
              },
            ),
            ListTile(
              title: Text('회원가입'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context)=>signIn())
                );
              },
            )
          ],
        ),
      );
    }
  }
}
