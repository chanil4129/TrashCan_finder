import 'package:flutter/material.dart';

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
            Container(
              width: double.infinity,
              height: 40,
              child: Category(),
              color: Colors.white,
            ),
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
                Navigator.pop(context);
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

class Category extends StatefulWidget{
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<Category>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            color: Colors.white,
            height: 50,
            child: Container(
                margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset('myasset/myimage/general_waste.png'),
                          label: Text('일반쓰레기'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset('myasset/myimage/plastic.png'),
                          label: Text('플라스틱'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset('myasset/myimage/can.png'),
                          label: Text('캔'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset('myasset/myimage/glass_bottle.png'),
                          label: Text('병'),
                          onSelected: (bool value) {},
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
      ),
    );
  }
}
