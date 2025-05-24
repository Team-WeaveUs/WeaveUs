import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:weave_us/controllers/owner_new_weave_controller.dart';

class MapSelectPin extends StatelessWidget {
  const MapSelectPin({super.key});

  @override
  Widget build(BuildContext context) {
    NaverMapController? naverMapController;
    final controller = Get.find<OwnerNewWeaveController>();

    return Obx(() {
      // position이 null인 경우 안전하게 처리
      final position = controller.position.value;
      final selectedLatLng = controller.selectedLatLng.value;

      if (position == null) {
        // position이 null일 때는 로딩 인디케이터를 표시
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          SizedBox(
            height: 200, // 레이아웃 문제 해결을 위해 고정 높이 지정
            child: NaverMap(
              onMapReady: (nController) {
                naverMapController = nController;
              },
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(position.latitude, position.longitude),
                  zoom: 11.5,
                ),
                indoorEnable: true,
                locationButtonEnable: false,
                consumeSymbolTapEvents: false,
              ),
              onMapTapped: (point, latLng) {
                controller.onMapTap(point, latLng);
                final marker = NMarker(id: 'marker', position: latLng);
                naverMapController?.addOverlayAll({marker});
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(controller.closestAreaName.value),
          ),
          Row(
            children: [
              // selectedLatLng가 null이 아닌 경우에만 좌표 표시
              Text(selectedLatLng != null
                  ? selectedLatLng.longitude.toString()
                  : "경도"),
              const SizedBox(
                width: 16,
              ),
              Text(selectedLatLng != null
                  ? selectedLatLng.latitude.toString()
                  : "위도"),
            ],
          ),
        ],
      );
    });
  }
}
