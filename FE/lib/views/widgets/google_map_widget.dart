import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울 좌표
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10), // 전체 패딩
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          onMapCreated: (controller) {
            mapController = controller;
          },
          zoomControlsEnabled: false, // 줌 버튼 제거
          mapToolbarEnabled: false,   // 우측 하단 툴바 제거
        ),
      ),
    );
  }
}
