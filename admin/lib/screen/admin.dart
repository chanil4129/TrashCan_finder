import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key,required this.logout}) : super(key: key);
  final VoidCallback logout;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        actions: [
          FloatingActionButton.extended(
            onPressed: widget.logout,
            label: Text('Logout'),
          )
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "가게명",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    labelText: '가게명 입력'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 80, 0),
                      child: Text(
                        "사용 여부",
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(90)
                    ),
                    Switch(onChanged: switchChanged, value: true)
                  ]),
              padding: EdgeInsets.all(0.0),
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "가능한 쓰레기 종류",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('일반쓰레기'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('플라스틱'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('페트병'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('캔'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('병'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('병'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('병'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('병'),
                            onSelected: (bool value) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InputChip(
                            avatar: Icon(Icons.remove),
                            label: Text('병'),
                            onSelected: (bool value) {},
                          ),
                        ),
                      ]),
                ),
                padding: EdgeInsets.all(0.0),
                alignment: Alignment.center,
                width: double.infinity,
                height: 50.0,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showToast('save');
                },
                tooltip: '저장',
                label: Text('저장'),
              ),
              padding: EdgeInsets.all(0.0),
              alignment: Alignment.centerRight,
              width: double.infinity,
              height: 20.0,
            )
          ]),
    );
  }

  void switchChanged(bool value) {

  }

  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
