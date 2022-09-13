import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:throw_away_main/Map/MarkerMap.dart';
import 'package:throw_away_main/data/Store_data.dart';
import 'package:throw_away_main/data/login_data.dart';

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
                            if (MemberInfo.mislogin) {
                              this.ProgramAccessShopData("GENERAL");
                            } else {
                              this.ProgramAccessShopData("GENERAL");
                              //DialogButton(context);
                            }
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
                            if (MemberInfo.mislogin) {
                              this.ProgramAccessShopData("PET");
                            } else {
                              DialogButton(context);
                            }
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
                            if (MemberInfo.mislogin) {
                              this.ProgramAccessShopData("CANS");
                            } else {
                              DialogButton(context);
                            }
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
                            if (MemberInfo.mislogin) {
                              this.ProgramAccessShopData("PAPER");
                            } else {
                              DialogButton(context);
                            }
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
        current_location = '''{"LNG":''' +
            _locationData.latitude.toString() +
            ''',"LAT":''' +
            _locationData.longitude.toString() +
            '''}''';

        currentUser.lat = double.parse(_locationData.latitude.toString());
        currentUser.lng = double.parse(_locationData.longitude.toString());
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

  void DialogButton(BuildContext context) {
    showDialog<String>(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("비로그인"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "로그인 후 이용 부탁드립니다.",
                ),
              ],
            ),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

final bool TestMode = false;
