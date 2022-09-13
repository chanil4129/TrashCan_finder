import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:throw_away_main/data/Store_data.dart';

class MarkerMapPage extends StatefulWidget {
  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<MarkerMapPage> {
  static const MODE_ADD = 0xF1;
  static const MODE_REMOVE = 0xF2;
  static const MODE_NONE = 0xF3;
  int _currentMode = MODE_NONE;
  List<Store> markerstore = shopes;

  MapType _mapType = MapType.Basic;

  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(trash),
        ),
        body: Column(
          children: <Widget>[
            _naverMap(),
          ],
        ),
      ),
    );
  }

  _naverMap() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          NaverMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(currentUser.lat, currentUser.lng),
              zoom: 17,
            ),
            onMapCreated: _onMapCreated,
            markers: markersData(),
            mapType: _mapType,
          ),
        ],
      ),
    );
  }

  List<Marker> markersData() {
    try {
      markerstore.forEach((store) {
        _markers.add(Marker(
            markerId: store.shopAddress,
            position: LatLng(store.shopLocation.lng, store.shopLocation.lat),
            captionText: store.shopName,
            captionColor: Colors.indigo,
            captionTextSize: 15.0,
            alpha: 0.8,
            captionOffset: 30,
            anchor: AnchorPoint(0.5, 1),
            width: 20,
            height: 30,
            onMarkerTab: _onMarkerTap));
      });
    } catch (e) {
      throw Exception("마커 업데이트 실패");
    }

    return _markers;
  }

  void _onMapCreated(NaverMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTap(LatLng latLng) {
    if (_currentMode == MODE_ADD) {
      _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: latLng,
        infoWindow: '테스트',
        onMarkerTab: _onMarkerTap,
      ));
      setState(() {});
    }
  }

  void _onMarkerTap(Marker marker, Map<String, int> iconSize) {
    DialogButton(context, marker);
  }

  void DialogButton(BuildContext context, Marker marker) {
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
                new Text(marker.captionText),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Text(marker.captionText + "길을 찾겠습니까?"))
              ],
            ),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("길찾기"),
                onPressed: () {
                  Get_Directions(marker);
                },
              ),
              new ElevatedButton(
                child: new Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void Get_Directions(Marker marker) async {
    try {
      String current_location_data =
          'slat=' + currentUser.lat.toString() + '&slng=' + currentUser.lng.toString();
      String shop_location_data = '&dlat=' + marker.position.latitude.toString() +
          '&dlng=' +
          marker.position.longitude.toString() + '&dname='+ marker.markerId+'&appname=com.example.throw_away_main';
      String get_dir = 'nmap://route/walk?'+shop_location_data;
      Uri uri = Uri.parse(get_dir);
      await launchUrl(uri);
    } catch (e) {
      throw Exception("gg");
    }
  }

// void Get_Directions(Marker marker) async{
//   String current_location_data =
//       currentUser.lng.toString() + ''',''' + currentUser.lat.toString();
//   String shop_location_data = marker.position.longitude.toString() +
//       ''',''' +
//       marker.position.latitude.toString();
//
//   String get_dir = "";
//   get_dir =
//       'https://naveropenapi.apigw.ntruss.com/map-direction/v1/walking?start=' +
//           current_location_data +
//           '&goal=' +
//           shop_location_data +
//           '&option=trafast';
//   // get_dir = 'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=127.1058342,37.359708&goal=129.075986,35.179470&option=trafast';
//   Uri url = Uri.parse(get_dir);
//   http.Response response = await http.get(url, headers: headers);
//
//   if (response != null) {
//     print(json.decode(response.body));
//   }
// }
//
// Map<String, String> headers = {
//   'X-NCP-APIGW-API-KEY-ID': 'w0vkkoekke',
//   'X-NCP-APIGW-API-KEY': 'PVUvKB9pWXTgHFQ4xtCCafvaJNRcne8KpzEjFY8x'
// };
}
