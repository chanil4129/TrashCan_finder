import 'dart:math';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
fetchStore() async{
  final uri = Uri.parse("http://52.79.202.39/?REQ=post_GET_ROOT_INFO&PHONE_NUM=01012345678&CATEGORY=SHOP");
  var response = await http.get(uri);
  print(response.body);
}
void main() async{
  fetchStore();
  //runApp(Admin());
}
/*class Store {
  final String shopName;
  final String shopAddress;
  final String shopNumber;
  final bool shopIsOpen;
  final int shopPoint;
  final  shopLocation;
  final trashType;
  Store({
    this.shopName='',
    this.shopAddress='',
    this.shopNumber='',
    this.shopIsOpen=false,
    this.shopPoint=0,
    this.trashType = {}
  });
  Store.fromJson(Map<String,dynamic> json)
      : shopName = json['SHOP_NAME'],
      shopAddress= json['SHOP_ADDRESS'],
      shopNumber=json['SHOP_NUMBER'],
      shopIsOpen= json['SHOP_IS_OPEN'],
      shopPoint=json['SHOP_POINT'],
      trashType = json['TRASH_TYPE'],
      shopLocation = json['SHOP_LOCATION'];

  Map<String,dynamic> toJson() => {
    'SHOP_NAME' : shopName,
    'SHOP_ADDRESS' : shopAddress,
    'SHOP_NUMBER':shopNumber,
    'SHOP_IS_OPEN':shopIsOpen,
    'SHOP_POINT':shopPoint,
    'TRASH_TYPE':trashType,
    'SHOP_LOCATION':shopLocation
  };
}*/

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  //Future<Store>? store;
  @override
  void initState(){
    super.initState();
    fetchStore();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Icon(Icons.format_list_bulleted_rounded),
                ],
              ),
              actions: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      spacing: 5,
                      children: <Widget>[
                        Icon(
                          Icons.control_point_duplicate,
                          color: Colors.blue,
                        ),
                        Text('적립금: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                )
              ],
              backgroundColor: Colors.amber,
            ),
            body: Container(
              padding: EdgeInsets.all(5),
              //margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                // border: Border.all(color: Colors.lightGreen, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  )
                                ]),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  child: Image.asset(
                                                    "assets/rawfish.jpg",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                ElevatedButton(onPressed: (){}, child: Text("변경 내용 저장",style: TextStyle(color: Colors.black),),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.amber
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                      Expanded(
                                          child: Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.pin_drop),
                                                Expanded(
                                                  child: Text(
                                                      "서울 마포구 독막로9길 9 1층",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.phone),
                                                Expanded(
                                                    child: Text(
                                                        "0507-1329-8117",
                                                        style: TextStyle(
                                                            fontSize: 12))),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "가게 활성화",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    //fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Switch(
                                                    activeColor:
                                                        Colors.blueAccent,
                                                    value: false,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        //_isOpen = value;
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(5),
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int idx) {
                              return Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  //border: Border.all(color: Colors.lightGreen, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                  color: Colors.white,
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Switch(
                                        activeColor: Colors.blueAccent,
                                        value: false,
                                        onChanged: (value) {
                                          setState(() {
                                            //Items[idx].isPos = value;
                                          });
                                        })
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int idx) =>
                                Divider(
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                // border: Border.all(color: Colors.lightGreen, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  )
                                ]),
                            child:
                              Column(
                                children: [
                                  Text("나중에 내역같은거 보여줄까?"),
                                ],
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
/*
Widget listview_separated() {
  return ListView.separated(
    padding: const EdgeInsets.all(10),
    itemCount: Items.length,
    itemBuilder: (BuildContext context, int idx) {
      return Container(
        height: 50,
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${Items[idx].category}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Switch(
                activeColor: Colors.blueAccent,
                value: Items[idx].isPos,
                onChanged: (value) {
                  //context.setState(() {
                  Items[idx].isPos = value;
                  //});
                })
          ],
        ),
      );
    },
    separatorBuilder: (BuildContext context, int idx) => Divider(
      height: 10.0,
      color: Colors.blue,
    ),
  );
}
*/
