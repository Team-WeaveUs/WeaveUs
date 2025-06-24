import 'package:get/get.dart';
import '../../controllers/owner_new_weave_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class MapSection extends GetView<OwnerNewWeaveController> {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController();
    return Stack(children: [
      Obx(() => controller.position.value == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    interactionOptions:
                    const InteractionOptions(
                        flags: InteractiveFlag.drag),
                    onTap: (tapPosition, latLng) {
                      controller.selectedLocation.value =
                          latLng;
                    },
                    initialCenter: LatLng(
                        controller.position.value!.latitude,
                        controller.position.value!.longitude),
                    initialZoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      tileProvider:
                      CancellableNetworkTileProvider(),
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        point:
                        controller.selectedLocation.value!,
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.orange,
                          size: 40,
                        ),
                      )
                    ])
                  ])))),
      Positioned(
        bottom: 5,
        right: 25,
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  final selectedLocation = controller.selectedLocation.value;
                  final currentZoom = mapController.camera.zoom;
                  mapController.move(selectedLocation!, currentZoom);
                },
                icon: const Icon(Icons.location_on_rounded, size: 30)),
            IconButton(
                onPressed: () {
                  final currentCenter = mapController.camera.center;
                  final currentZoom = mapController.camera.zoom + 1;
                  mapController.move(currentCenter, currentZoom);
                },
                icon: const Icon(Icons.zoom_in, size: 30)),
            IconButton(
                onPressed: () {
                  final currentCenter = mapController.camera.center;
                  final currentZoom = mapController.camera.zoom - 1;
                  mapController.move(currentCenter, currentZoom);
                },
                icon: const Icon(Icons.zoom_out, size: 30)),
          ],
        ),)
    ]);
  }
}