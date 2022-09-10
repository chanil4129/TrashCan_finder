import 'package:flutter/material.dart';
import 'package:throw_away_main/Drawer/drawer_main.dart';

class Login extends StatefulWidget {
  const Login({Key? key,required this.title,required this.login_onSubmit}) : super(key: key);
  final String title;
  final VoidCallback login_onSubmit;
  static final TextEditingController user_ID=new TextEditingController();
  static final TextEditingController user_Password=new TextEditingController();

  String get userid=>user_ID.text;
  String get userpw=>user_Password.text;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('login',style: TextStyle(fontSize: 36),),
            Padding(
              padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
              child: TextField(
                controller: Login.user_ID,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: 'ID'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
              child: TextField(
                controller: Login.user_Password,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: 'Password'
                ),
              ),
            ),
            FloatingActionButton.extended(
              heroTag: 'login',
              onPressed: widget.login_onSubmit,
              tooltip: 'login',

              label: Text('login'),
              icon: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
