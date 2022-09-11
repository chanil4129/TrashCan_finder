import 'dart:math';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Shop shop = Shop();

Future<Store> fetchStore(String sa) async {
  final uri = Uri.parse(
      "http://52.79.202.39/?REQ=post_GET_ROOT_INFO&PHONE_NUM=${sa}&CATEGORY=SHOP");
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    print("SUCCESSFULLY GET");
    print(json.decode(response.body));
    return Store.fromJson(json.decode(response.body));
  } else {
    throw Exception("정보 가져오기 실패");
  }
}

Future<bool> postStore(Shop store) async {
  final response = await http.post(
    Uri.parse(
        "http://52.79.202.39/?REQ=post_PUT_ROOT_INFO&PHONE_NUM=${store.shopNumber}&CATEGORY=SHOP&JSON_UPDATE="
            "{"
            "\"SHOP_NAME\":\"${store.shopName}\","
            "\"SHOP_ADDRESS\":\"${store.shopAddress}\","
            "\"ID_AUX\":\"${store.shopNumber}\","
            "\"SHOP_IS_OPEN\":${store.shopIsOpen},"
            "\"SHOP_POINT\":${store.shopPoint},"
            "\"TRASH_TYPE\":{"
            "\"GENERAL\":${store.trashFlag[0]},"
            "\"PET\":${store.trashFlag[1]},"
            "\"CANS\":${store.trashFlag[2]},"
            "\"PAPER\":${store.trashFlag[3]}"
            "},"
            "\"SHOP_LOCATION\":{"
            "\"LNG\":${store.shopLocation[0]},"
            "\"LAT\":${store.shopLocation[1]}"
            "}"
            "}"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'SHOP_NAME': store.shopName,
      'SHOP_ADDRESS': store.shopAddress,
      'ID_AUX': store.shopNumber,
      'SHOP_IS_OPEN': store.shopIsOpen,
      'SHOP_POINT': store.shopPoint,
      'TRASH_TYPE': {
        'GENERAL': store.trashFlag[0],
        'PET': store.trashFlag[1],
        'CANS': store.trashFlag[2],
        'PAPER': store.trashFlag[3]
      },
      'SHOP_LOCATION': {
        'LNG': store.shopLocation[0],
        'LAT': store.shopLocation[1]
      }
    }),
  );
  if (response.statusCode == 200) {
    print("수정 완료~");
    return true;
  } else {
    print("수정 실패");
  }
  return false;
}

class ShopLocation {
  late double lng;
  late double lat;

  ShopLocation({required this.lng, required this.lat});

  factory ShopLocation.fromJson(Map<String, dynamic> json) {
    shop.shopLocation[0] = json['LNG'];
    shop.shopLocation[1] = json['LAT'];
    return ShopLocation(lng: json['LNG'], lat: json['LAT']);
  }
}

List<String> trashName = ['일반쓰레기', '플라스틱/페트', '병/캔', '종이/박스'];
List<bool> trashFlag = [false, false, false, false];
bool shopOpen = false;

class TrashType {
  late bool general;
  late bool pet;
  late bool cans;
  late bool paper;

  TrashType({
    required this.general,
    required this.pet,
    required this.cans,
    required this.paper,
  });

  factory TrashType.fromJson(Map<String, dynamic> json) {
    shop.trashFlag[0] = json['GENERAL'];
    shop.trashFlag[1] = json['PET'];
    shop.trashFlag[2] = json['CANS'];
    shop.trashFlag[3] = json['PAPER'];
    return TrashType(
      general: json['GENERAL'],
      pet: json['PET'],
      cans: json['CANS'],
      paper: json['PAPER'],
    );
  }
}

class Shop {
  String shopName = "가게명";
  String shopAddress = "주소";
  String shopNumber = "전화번호";
  bool shopIsOpen = false;
  double shopPoint = 0;
  bool start = false;
  List<double> shopLocation = [0, 0];
  List<String> trashName = ['일반쓰레기', '플라스틱/페트', '병/캔', '종이/박스'];
  List<bool> trashFlag = [false, false, false, false];
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
    shop.shopIsOpen = json['SHOP_IS_OPEN'];
    shop.shopName = json['SHOP_NAME'];
    shop.shopAddress = json['SHOP_ADDRESS'];
    shop.shopNumber = json['ID_AUX'];
    shop.shopPoint = json['SHOP_POINT'];
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
  const Admin({Key? key,required this.shopAux}) : super(key: key);
  final String shopAux;

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  late Future<Store> store;
  bool switchFlag = shop.shopIsOpen;
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _shopNumberController = TextEditingController();

  void _handleSubmitted() {
    _shopNameController.clear();
    _shopAddressController.clear();
    _shopNumberController.clear();
  }



  @override
  void initState() {
    super.initState();
    store = fetchStore(widget.shopAux);
    setState(() {
      shop.start = true;
    });
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
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                );
                              } else {
                                return Text('적립금: ${shop.shopPoint}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold));
                              }
                            })
                      ],
                    ),
                  ],
                )
              ],
              backgroundColor: Colors.amber,
            ),
            body:
            FutureBuilder(
                future: store,
                builder: (BuildContext context,AsyncSnapshot snapshot) {
                  shop.start = true;
                  return Container(
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
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      shop.shopName,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          postStore(shop)
                                                              .then((value) => {
                                                            if (value){

                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text('변경 내용 저장 완료!'),
                                                                ),
                                                              )
                                                            }
                                                            else
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text('** 수정 실패 **'),
                                                                  ),
                                                                )
                                                              }
                                                          });
                                                        },
                                                        child: Text("변경 내용 저장"))
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.pin_drop),
                                                    Expanded(
                                                      child: Text(shop.shopAddress,
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
                                                        child: Text(shop.shopNumber, style: TextStyle(fontSize: 12))),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("가게 활성화", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                                                        ),
                                                        Switch(
                                                            value: shop.shopIsOpen,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                shop.shopIsOpen = value;
                                                                print(shop.shopIsOpen);
                                                                //print(shop.shopIsOpen);
                                                              });
                                                            })
                                                      ],
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          showDialog(context: context,
                                                              //barrierDismissible: false,
                                                              builder: (BuildContext context){
                                                                return AlertDialog(
                                                                    title: Text('프로필 설정',style: TextStyle(fontWeight: FontWeight.bold),),
                                                                    content: SingleChildScrollView(
                                                                      child: Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: TextField(
                                                                              controller: _shopNameController,
                                                                              decoration: InputDecoration(
                                                                                  labelText: "가게 이름",
                                                                                  hintText: shop.shopName,
                                                                                  filled : true,
                                                                                  fillColor: Colors.white60,
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                  )
                                                                              ),
                                                                              onSubmitted: (String value) {
                                                                                // _shopNameController.clear();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: TextField(
                                                                              controller: _shopAddressController,
                                                                              decoration: InputDecoration(
                                                                                  labelText: "주소",
                                                                                  hintText: shop.shopAddress,
                                                                                  filled : true,
                                                                                  fillColor: Colors.white60,
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                  )
                                                                              ),
                                                                              onSubmitted: (String value) {
                                                                                //_shopAddressController.clear();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: TextField(
                                                                              controller: _shopNumberController,
                                                                              decoration: InputDecoration(
                                                                                  labelText: "전화번호",
                                                                                  hintText: shop.shopNumber,
                                                                                  filled : true,
                                                                                  fillColor: Colors.white60,
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                  )
                                                                              ),
                                                                              onSubmitted: (String value) {
                                                                                // _shopNumberController.clear();
                                                                              },
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions :[
                                                                      ElevatedButton(onPressed: (){
                                                                        if(_shopNameController.text != ''){
                                                                          shop.shopName = _shopNameController.text;
                                                                        }
                                                                        if(_shopAddressController.text != ''){
                                                                          shop.shopAddress = _shopAddressController.text;
                                                                        }
                                                                        if(_shopNumberController.text != ''){
                                                                          shop.shopNumber = _shopNumberController.text;
                                                                        }
                                                                        postStore(shop)
                                                                            .then((value) => {
                                                                          if (value){
                                                                            setState((){
                                                                              shop.shopName = shop.shopName;
                                                                              shop.shopNumber = shop.shopNumber;
                                                                              shop.shopAddress = shop.shopAddress;
                                                                            }),
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Text('가게 정보 수정 완료!'),
                                                                              ),
                                                                            )
                                                                          }
                                                                          else
                                                                            {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text('** 수정 실패 **'),
                                                                                ),
                                                                              )
                                                                            }
                                                                        });
                                                                        _handleSubmitted();
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                          child: Text('저장')
                                                                      ),
                                                                      ElevatedButton(onPressed: (){
                                                                        _handleSubmitted();
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                          child: Text('닫기'),
                                                                          style: ElevatedButton.styleFrom(
                                                                            primary: Colors.red,
                                                                            onPrimary: Colors.black,
                                                                          )
                                                                      )
                                                                    ]
                                                                );
                                                              }
                                                          );
                                                        },
                                                        icon: Icon(Icons.settings))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
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
                                  builder:
                                      (BuildContext context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasError) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      );
                                    } else {
                                      return Expanded(
                                        child: ListView.separated(
                                          padding: const EdgeInsets.all(5),
                                          itemCount: trashName.length,
                                          itemBuilder:
                                              (BuildContext context, int idx) {
                                            return Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(50),
                                                //border: Border.all(color: Colors.lightGreen, width: 3),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                    Colors.grey.withOpacity(0.5),
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
                                                    shop.trashName[idx],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Switch(
                                                      activeColor: Colors.blueAccent,
                                                      value: shop.trashFlag[idx],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          shop.trashFlag[idx] = value;
                                                        });
                                                      })
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context, int idx) =>
                                              Divider(
                                                height: 10.0,
                                                color: Colors.white,
                                              ),
                                        ),
                                      );
                                    }
                                  }),
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
                  );
                }
            )));
  }
}