import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDialog extends StatelessWidget {
  final Function(String) onLocationSelected;

  const MapDialog({super.key, required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    // 초기 카메라 위치 (예: 서울)
    const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.5665, 126.9780), // 서울 좌표
      zoom: 12,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        height: 500, // 다이얼로그 크기
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "지도를 탐색하여 위치를 선택하세요",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Google Maps 표시
            Expanded(
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                myLocationEnabled: true, // 내 위치 표시 활성화
                myLocationButtonEnabled: true, // 내 위치 버튼 표시
                zoomControlsEnabled: true, // 줌 컨트롤 표시
                onTap: (LatLng position) {
                  // 사용자가 지도에서 위치를 선택하면 위치 데이터를 반환
                  onLocationSelected("위치 좌표: ${position.latitude}, ${position.longitude}");
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 16),

            // 닫기 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text("닫기"),
            ),
          ],
        ),
      ),
    );
  }
}