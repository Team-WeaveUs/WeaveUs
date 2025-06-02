import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

import '../../../controllers/search_controller.dart';

import 'search_result_list.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeaveSearchController>();

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
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(controller.position.value!.latitude, controller.position.value!.longitude),
                    zoom: 11.5,
                  ),
                  indoorEnable: true,
                  locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                  consumeSymbolTapEvents: false,
                ),
                onMapReady: (r) {
                  // final marker = NMarker(id: "test", position: NLatLng(controller.position.value!.latitude, controller.position.value!.longitude));
                  r.addOverlayAll(controller.mapMarkers);
                }

            ),
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
