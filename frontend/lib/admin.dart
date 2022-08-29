import 'dart:math';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Item{
  final String category= '';
  bool isPos = false;
}

String _storeName = '시실리';
int _reserves = 4567; // 적립금
bool _isOpen = true;

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                RichText(
                    text: TextSpan(
                        text: '가계명',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: ' $_storeName',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ])),
                Switch(
                    activeColor: Colors.blueAccent,
                    value: _isOpen,
                    onChanged: (value) {
                      setState(() {
                        _isOpen = value;
                      });
                    }),
              ],
            ),
            actions: [
              Row(
                children: [
                  Wrap(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 5,
                    children: <Widget>[
                      Icon(Icons.control_point_duplicate),
                      Text('적립금: $_reserves'),
                    ],
                  ),
                ],
              )
            ],
            backgroundColor: Colors.orangeAccent,
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                   Column(
                     children: [
                       Text('카테고리')
                     ],
                   )
                  ],
                ),
                Row(

                )
              ],
            ),
          )
        ));
  }
}
