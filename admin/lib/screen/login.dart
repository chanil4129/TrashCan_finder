import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'admin.dart';
import 'package:admin/main.dart';
import 'signin.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.onSubmit}) : super(key: key);
  final String title;
  final VoidCallback onSubmit;
  static final TextEditingController user_ID=new TextEditingController();
  static final TextEditingController user_Password=new TextEditingController();

  String get userid=>user_ID.text;
  String get userpw=>user_Password.text;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          FloatingActionButton.extended(
              onPressed: (){
                Navigator.push(
                    context, 
                    CupertinoPageRoute(builder: (context)=>signIn())
                );
              },
            label: Text('signIn'),
          )
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('login',style: TextStyle(fontSize: 36),),
              Padding(
                padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                child: TextField(
                  controller: MyHomePage.user_ID,
                  decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: 'ID'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                child: TextField(
                  controller: MyHomePage.user_Password,
                  decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: 'Password'
                  ),
                ),
              ),
              FloatingActionButton.extended(
                onPressed: widget.onSubmit,
                tooltip: 'login',

                label: Text('login'),
                icon: Icon(Icons.arrow_right),
              ),
            ],
          ),
        ));
  }
}
