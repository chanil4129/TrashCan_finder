import 'package:flutter/material.dart';

class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sign in'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              '이름',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: '이름을 입력하세요'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
            child: Text(
              'ID',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto"
            ),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: [
                Container(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        labelText: 'ID를 입력하세요'),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      label: Text('ID확인'),
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto"
            ),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: '비밀번호를 입력하세요'),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
            onPressed: () {},
            label: Text('sign in'),
          )),
        ],
      ),
    );
  }
}
