import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

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
              child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(controller.position.value!.latitude,
                        controller.position.value!.longitude),
                    initialZoom: 15.5,
                    maxZoom: 18.0,
                    minZoom: 3.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      tileProvider: CancellableNetworkTileProvider(),
                    ),
                    MarkerLayer(
                        markers: controller.joinWeaveData.map((weave) {
                      return Marker(
                        point: LatLng(weave.lat, weave.lng),
                        child: GestureDetector(
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.orange,
                            size: 40,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.toNamed('/weave/${weave.weaveId}');
                          },
                        ),
                      );
                    }).toList())
                  ])),
          if (hasResults) ...[
            const SizedBox(height: 16),
            const Expanded(child: SearchResultList()),
          ]
        ],
      );
    });
  }
}
