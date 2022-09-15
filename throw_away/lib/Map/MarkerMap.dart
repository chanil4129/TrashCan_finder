import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:throw_away_main/data/Store_data.dart';
import 'package:throw_away_main/QR/QR.dart';

class MarkerMapPage extends StatefulWidget {
  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<MarkerMapPage> {
  List<U_Store> markerstore = shopes;

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
          Positioned(
            child: Container(
              color: Colors.transparent,
              width: 100,
              height: 100,
              child: QR_View(),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
            ),
            bottom: 0,
            right: 0,
          )
        ],
      ),
    );
  }

  List<Marker> markersData() {
    try {
        markerstore.forEach((store) {
          _markers.add(Marker(
              markerId: store.shopAddress,
              position: LatLng(store.shopLocation.lat, store.shopLocation.lng),
              captionText: store.shopIsOpen ? store.shopName : "영업준비중",
              captionColor: Colors.indigo,
              captionTextSize: 15.0,
              alpha: 0.8,
              captionOffset: 30,
              anchor: AnchorPoint(0.5, 1),
              width: 20,
              height: 30,
              onMarkerTab: _onMarkerTap));
        });
        return _markers;
    } catch (e) {
      throw Exception("마커 업데이트 실패");
    }

    return _markers;
  }

  void _onMapCreated(NaverMapController controller) {
    _controller.complete(controller);
  }

  void _onMarkerTap(Marker marker, Map<String, int> iconSize) {
    if (marker.captionText.contains("영업준비중")) {
      AlreadyStore(context, marker);
    } else {
      DialogButton(context, marker);
    }
  }

  void AlreadyStore(BuildContext context, Marker marker) {
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
              children: <Widget>[Center(child: Text("영업준비중입니다."))],
            ),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("닫기"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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
      Navigator.pop(context);
      String current_location_data = 'slat=' +
          currentUser.lat.toString() +
          '&slng=' +
          currentUser.lng.toString();
      String shop_location_data = '&dlat=' +
          marker.position.latitude.toString() +
          '&dlng=' +
          marker.position.longitude.toString() +
          '&dname=' +
          marker.markerId +
          '&appname=com.example.throw_away_main';
      String get_dir = 'nmap://route/walk?' + shop_location_data;
      Uri uri = Uri.parse(get_dir);
      await launchUrl(uri);

    } catch (e) {
      throw Exception("gg");
    }
  }
}
