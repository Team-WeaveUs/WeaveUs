import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapWidget extends StatefulWidget {
  const NaverMapWidget({super.key});

  @override
  State<NaverMapWidget> createState() => _NaverMapWidgetState();
}

class _NaverMapWidgetState extends State<NaverMapWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(37.304438, 127.1095711),
              zoom: 5,
            ),
            indoorEnable: true,
            locationButtonEnable: false, // 위치 버튼 표시 여부 설정
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (controller) {
            final marker = NMarker(id: "test", position: NLatLng(37.304438, 127.1095711));
            controller.addOverlayAll({marker});
          }
        ),
    );
  }
}
