import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
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
  int i = 1;

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
            markerId: i.toString(),
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
        i++;
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
    int pos = _markers.indexWhere((m) => m.markerId == marker.markerId);
    setState(() {
      _markers[pos].captionText = '선택됨';
    });
    if (_currentMode == MODE_REMOVE) {
      setState(() {
        _markers.removeWhere((m) => m.markerId == marker.markerId);
      });
    }
  }
}
