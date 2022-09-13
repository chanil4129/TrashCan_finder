import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMap_User extends StatefulWidget {
  @override
  _NaverMapUserState createState() => _NaverMapUserState();
}

///네이버 맵 위젯
class _NaverMapUserState extends State<NaverMap_User> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NaverMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.566352778, 126.977952778),
            zoom: 17,
          ),
          onMapCreated: onMapCreated,
          mapType: _mapType,
          locationButtonEnable: true,
        ),
      ),
    );
  }
  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}