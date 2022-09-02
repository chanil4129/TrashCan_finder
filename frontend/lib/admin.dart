import 'dart:math';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Store> fetchStore() async {
  final uri = Uri.parse(
      "http://52.79.202.39/?REQ=post_GET_ROOT_INFO&PHONE_NUM=01012345678&CATEGORY=SHOP");
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    print("SUCCESSFULLY GET");
    print(json.decode(response.body));
    return Store.fromJson(json.decode(response.body));
  } else {
    throw Exception("정보 가져오기 실패");
  }
}

void main() async {
  fetchStore();
  runApp(Admin());
}

class ShopLocation {
  late double lng;
  late double lat;

  ShopLocation({required this.lng, required this.lat});

  factory ShopLocation.fromJson(Map<String, dynamic> json) {
    return ShopLocation(lng: json['LNG'], lat: json['LAT']);
  }
}
List <String> trashName = ['일반쓰레기','플라스틱/페트','병/캔','종이/박스'];
List <bool> trashFlag = [false,false,false,false];
class TrashType {
  late bool general;
  late bool pet;
  late bool cans;
  late bool paper;
  TrashType(
      {required this.general,
        required this.pet,
        required this.cans,
        required this.paper,
      });

  factory TrashType.fromJson(Map<String, dynamic> json) {
    trashFlag[0] = json['GENERAL'];
    trashFlag[1] = json['PET'];
    trashFlag[2] = json['CANS'];
    trashFlag[3] =  json['PAPER'];
    return TrashType(
        general: json['GENERAL'],
        pet: json['PET'],
        cans: json['CANS'],
        paper: json['PAPER'],
    );
  }
}

class Store {
  final String shopName;
  final String shopAddress;
  final String shopNumber;
  final bool shopIsOpen;
  final int shopPoint;
  final shopLocation;
  final trashType;

  Store(
      {required this.shopName,
        required this.shopAddress,
        required this.shopNumber,
        required this.shopIsOpen,
        required this.shopPoint,
        required this.shopLocation,
        required this.trashType});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        shopName: json['SHOP_NAME'],
        shopAddress: json['SHOP_ADDRESS'],
        shopNumber: json['ID_AUX'],
        shopIsOpen: json['SHOP_IS_OPEN'],
        shopPoint: json['SHOP_POINT'],
        trashType: TrashType.fromJson(json['TRASH_TYPE']),
        shopLocation: ShopLocation.fromJson(json['SHOP_LOCATION']));
  }

  Map<String, dynamic> toJson() => {
    'SHOP_NAME': shopName,
    'SHOP_ADDRESS': shopAddress,
    'ID_AUX': shopNumber,
    'SHOP_IS_OPEN': shopIsOpen,
    'SHOP_POINT': shopPoint,
    'TRASH_TYPE': trashType,
    'SHOP_LOCATION': shopLocation
  };
}

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  late Future<Store> store;
  @override
  void initState() {
    super.initState();
    store = fetchStore();
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
                        FutureBuilder<Store>(
                            future: store,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == false) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                );
                              }else{
                                print(snapshot.data.shopPoint);
                                return  Text('적립금: ${snapshot.data.shopPoint}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold));
                              }
                            }
                        )
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
                                          child:
                                          FutureBuilder<Store>(
                                              future: store,
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                if (snapshot.hasData == false) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Error: ${snapshot.error}',
                                                      style: TextStyle(fontSize: 15),
                                                    ),
                                                  );
                                                }else{
                                                  return  Container(
                                                    margin: const EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              snapshot.data.shopName,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20),
                                                            ),
                                                            ElevatedButton(onPressed: (){}, child: Text("변경 내용 저장"))
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Icon(Icons.pin_drop),
                                                            Expanded(
                                                              child: Text(
                                                                  snapshot.data.shopAddress,
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
                                                                    snapshot.data.shopNumber,
                                                                    style: TextStyle(
                                                                        fontSize: 12))),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
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
                                                                    value: snapshot.data.shopIsOpen,
                                                                    onChanged: (value) {
                                                                      setState(() {
                                                                        snapshot.data.shopIsOpen = value;
                                                                      });
                                                                    }),
                                                              ],
                                                            ),
                                                            IconButton(onPressed: (){}, icon: Icon(Icons.settings))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                          )
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
                        FutureBuilder<Store>(
                            future: store,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == false) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                );
                              }else{
                                print(snapshot.data.trashType);
                                return  Expanded(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(5),
                                    itemCount: trashName.length,
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
                                              trashName[idx],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Switch(
                                                activeColor: Colors.blueAccent,
                                                value: trashFlag[idx],
                                                onChanged: (value) {
                                                  setState(() {
                                                    trashFlag[idx] = value;
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
                                );

                            }
                            }
                        )
                        ,
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
                            child: Column(
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