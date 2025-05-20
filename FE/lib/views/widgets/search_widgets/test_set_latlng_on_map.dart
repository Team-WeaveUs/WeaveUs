import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

import '../../../controllers/new_join_weave_controller.dart';
import '../../../controllers/search_controller.dart';

import 'search_result_list.dart';

class MapSelectPin extends StatelessWidget {
  const MapSelectPin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeaveSearchController>();
    final newJoinWeaveController = Get.find<NewJoinWeaveController>();
    NaverMapController? _naverMapController;

    return Obx(() {
      final isFolded = controller.isMapFolded.value;
      final hasResults = controller.searchResults.isNotEmpty;

      return Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isFolded
                ? MediaQuery.of(context).size.height * 0.35
                : MediaQuery.of(context).size.height * 0.65,
            child: NaverMap(
                onMapReady: (controller) {
                  _naverMapController = controller;
                },
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(controller.position.value!.latitude,
                        controller.position.value!.longitude),
                    zoom: 11.5,
                  ),
                  indoorEnable: true,
                  locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                  consumeSymbolTapEvents: false,
                ),
                onMapTapped: (point, latLng) {
                  newJoinWeaveController.onMapTap(point, latLng);
                  final marker = NMarker(id: 'marker', position: latLng);
                  _naverMapController?.addOverlayAll({marker});
                },
            ),
          ),
          Text(newJoinWeaveController.closestAreaName.value),
          Row(
            children: [
              Text(newJoinWeaveController.selectedLatLng.value!.longitude.toString()),
              SizedBox(width: 16,),
              Text(newJoinWeaveController.selectedLatLng.value!.latitude.toString()),
            ],
          ),
          if (hasResults) ...[
            const SizedBox(height: 16),
            const Expanded(child: SearchResultList()),
          ]
        ],
      );
    });
  }
}
