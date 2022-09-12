import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:throw_away_main/Map/MarkerMap.dart';
import 'package:throw_away_main/data/Store_data.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryItemState();
}

/// 카테고리 위젯 만드는 클래스
class _CategoryItemState extends State<Category> {
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            height: 40,
            child: Container(
                margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FloatingActionButton.extended(
                          heroTag: 'General',
                          onPressed: () {
                            this.ProgramAccessShopData("GENERAL");
                          },
                          icon: new Image.asset(
                              'myasset/myimage/general_waste.png'),
                          label: Text('일반쓰레기'),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FloatingActionButton.extended(
                          heroTag: 'pet',
                          onPressed: () {
                            this.ProgramAccessShopData("PET");
                          },
                          icon: new Image.asset('myasset/myimage/plastic.png'),
                          label: Text('플라스틱'),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FloatingActionButton.extended(
                          heroTag: 'cans',
                          onPressed: () {
                            this.ProgramAccessShopData("CANS");
                          },
                          icon: new Image.asset('myasset/myimage/can.png'),
                          label: Text('캔'),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FloatingActionButton.extended(
                          heroTag: 'paper',
                          onPressed: () {
                            this.ProgramAccessShopData("PAPER");
                          },
                          icon: new Image.asset(
                              'myasset/myimage/glass_bottle.png'),
                          label: Text('종이'),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  ///카테고리 클릭시 Shop데이터 받아오는함수
  Future<void> ProgramAccessShopData(String trashType) async {
    ///위치 받아오는값
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    trash = trashType;
    try {

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }
      _locationData = await location.getLocation();
    }
    catch(e){

    }
    ///여기까지

    ///주변 가게정보들 서버에 요청
    try {
      String current_location = "";
      if (TestMode) {
        current_location =
            '''{"LNG":''' + '37.557' + ''',"LAT":''' + '126.92' + '''}''';

        currentUser.lat = 37.557;
        currentUser.lng = 126.92;
      } else {
        ///다시 살려야됨
        // current_location = '''{"LNG":''' +
        //     _locationData.longitude.toString() +
        //     ''',"LAT":''' +
        //     _locationData.latitude.toString() +
        //     '''}''';
        //
        // currentUser.lat = _locationData.latitude;
        // currentUser.lng = _locationData.longitude;
      }


      String geturl =
          'http://52.79.202.39/?REQ=post_GET_NEAR_SHOP&CUR_LOCATION=' +
              current_location +
              '&CATEGORY=' +
              'SHOP' +
              '&TRASH_TYPE=' +
              trashType;
      Uri url = Uri.parse(geturl);

      ///여기까지

      ///가게 주변정보 데이터에 담기
      List<Store> _datas = [];
      var _text = "";
      http.Response response = await http.get(url);

      if (response != null) {
        print(json.decode(response.body));
        _text = utf8.decode(response.bodyBytes);
        var dataObjsJson = jsonDecode(_text) as List;
        final List<Store> parsedResponse =
            dataObjsJson.map((dataJson) => Store.fromJson(dataJson)).toList();
        _datas.clear();
        _datas.addAll(parsedResponse);
        shopes = _datas;
        print(parsedResponse);
      } else {
        print("hi");
      }

      ///가게 랭킹
      String rankurl =
          'http://52.79.202.39/?REQ=post_GET_SHOP_RANK&CUR_LOCATION=' +
              current_location +
              '&CATEGORY=' +
              'SHOP';
      Uri rank = Uri.parse(rankurl);

      List<Store> _ranks = [];
      _text = "";
      http.Response rank_response = await http.get(rank);

      if (rank_response != null) {
        print(json.decode(rank_response.body));
        _text = utf8.decode(rank_response.bodyBytes);
        var dataObjsJson = jsonDecode(_text) as List;
        final List<Store> parsedResponse =
            dataObjsJson.map((dataJson) => Store.fromJson(dataJson)).toList();
        _ranks.clear();
        _ranks.addAll(parsedResponse);
        shop_ranks = _ranks;
        print(parsedResponse);
      } else {
        print("hi");
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarkerMapPage(),
          ));

      ///여기까지

    } catch (e) {
      throw Exception("정보 가져오기 실패");
    }

    ///여기까지
  }
}

// currentLocation currentUser = currentLocation();
//
// ///가게 하나만 담아서 넣어주는 곳
// Shop shop = Shop();
//
// ///쓰레기 종류
// String trash = "";
//
// ///가게 전체를 담는 리스트
// List<Store> shopes = [];
// List<Store> shop_ranks = [];
//
// ///개개인 가게 정보 클래스
// class Shop {
//   String shopName = "가게명";
//   String shopAddress = "주소";
//   String shopNumber = "전화번호";
//   bool shopIsOpen = false;
//   int shopPoint = 0;
//   List<double> shopLocation = [0, 0];
//   List<bool> trashFlag = [false, false, false, false];
// }
//
// ///가게 위치 리스트 받는부분
// class ShopLocation {
//   late double lng;
//   late double lat;
//
//   ShopLocation({required this.lng, required this.lat});
//
//   factory ShopLocation.fromJson(Map<String, dynamic> json) {
//     shop.shopLocation[0] = json['LNG'];
//     shop.shopLocation[1] = json['LAT'];
//     return ShopLocation(lng: json['LNG'], lat: json['LAT']);
//   }
// }
//
// List<bool> trashFlag = [false, false, false, false];
// bool shopOpen = false;
//
// ///카테고리 종류 받는 부분
// class TrashType {
//   late bool general;
//   late bool pet;
//   late bool cans;
//   late bool paper;
//
//   TrashType({
//     required this.general,
//     required this.pet,
//     required this.cans,
//     required this.paper,
//   });
//
//   factory TrashType.fromJson(Map<String, dynamic> json) {
//     shop.trashFlag[0] = json['GENERAL'];
//     shop.trashFlag[1] = json['PET'];
//     shop.trashFlag[2] = json['CANS'];
//     shop.trashFlag[3] = json['PAPER'];
//     return TrashType(
//       general: json['GENERAL'],
//       pet: json['PET'],
//       cans: json['CANS'],
//       paper: json['PAPER'],
//     );
//   }
// }
//
// ///전체적으로 가게 모든 데이터를 받는 부분
// class Store {
//   final String shopName;
//   final String shopAddress;
//   final String shopNumber;
//   final bool shopIsOpen;
//   final int shopPoint;
//   final ShopLocation shopLocation;
//   final TrashType trashType;
//
//   Store(
//       {required this.shopName,
//       required this.shopAddress,
//       required this.shopNumber,
//       required this.shopIsOpen,
//       required this.shopPoint,
//       required this.shopLocation,
//       required this.trashType});
//
//   factory Store.fromJson(Map<String, dynamic> json) {
//     shop.shopIsOpen = json['SHOP_IS_OPEN'];
//     shop.shopName = json['SHOP_NAME'];
//     shop.shopAddress = json['SHOP_ADDRESS'];
//     shop.shopNumber = json['ID_AUX'];
//     shop.shopPoint = json['SHOP_POINT'];
//     return Store(
//         shopName: json['SHOP_NAME'],
//         shopAddress: json['SHOP_ADDRESS'],
//         shopNumber: json['ID_AUX'],
//         shopIsOpen: json['SHOP_IS_OPEN'],
//         shopPoint: json['SHOP_POINT'],
//         shopLocation: ShopLocation.fromJson(json['SHOP_LOCATION']),
//         trashType: TrashType.fromJson(json['TRASH_TYPE']));
//   }
//
//   Map<String, dynamic> toJson() => {
//         'SHOP_NAME': shopName,
//         'SHOP_ADDRESS': shopAddress,
//         'ID_AUX': shopNumber,
//         'SHOP_IS_OPEN': shopIsOpen,
//         'SHOP_POINT': shopPoint,
//         'TRASH_TYPE': trashType,
//         'SHOP_LOCATION': shopLocation
//       };
// }
//
// class currentLocation {
//   String lat = "";
//   String lng = "";
// }

final bool TestMode = true;
