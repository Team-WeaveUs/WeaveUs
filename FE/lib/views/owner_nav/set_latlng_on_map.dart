import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:weave_us/controllers/owner_new_weave_controller.dart';
import '../widgets/map_select_modal.dart';

class MapSelectPin extends StatelessWidget {
  const MapSelectPin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerNewWeaveController>();

    return Obx(() {
      final position = controller.position.value;
      final selectedLatLng = controller.selectedLatLng.value;

      if (position == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return GestureDetector(
        onTap: () {
          Get.dialog(
            MapSelectModal(
              initialPosition: selectedLatLng ??
                  NLatLng(position.latitude, position.longitude),
              onLocationSelected: (latLng) {
                controller.onMapTap(
                  NPoint(
                      latLng.longitude.toDouble(), latLng.latitude.toDouble()),
                  latLng,
                );
              },
            ),
            barrierDismissible: true,
          );
        },
        child: Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                      target: selectedLatLng ??
                          NLatLng(position.latitude, position.longitude),
                      zoom: 15,
                    ),
                    scrollGesturesEnable: false,
                    zoomGesturesEnable: false,
                    rotationGesturesEnable: false,
                    tiltGesturesEnable: false,
                  ),
                  onMapReady: (mapController) {
                    if (selectedLatLng != null) {
                      final marker = NMarker(
                        id: 'marker',
                        position: selectedLatLng,
                      );
                      mapController.addOverlay(marker);
                    }
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 32,
                          color: selectedLatLng == null
                              ? Colors.grey[600]
                              : Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedLatLng == null
                              ? '위치를 선택하려면 탭하세요'
                              : '탭하여 위치 변경',
                          style: TextStyle(
                            color: selectedLatLng == null
                                ? Colors.grey[600]
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            shadows: selectedLatLng == null
                                ? null
                                : const [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    ),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
