import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class MapSelectModal extends StatefulWidget {
  final NLatLng? initialPosition;
  final Function(NLatLng) onLocationSelected;

  const MapSelectModal({
    super.key,
    this.initialPosition,
    required this.onLocationSelected,
  });

  @override
  State<MapSelectModal> createState() => _MapSelectModalState();
}

class _MapSelectModalState extends State<MapSelectModal> {
  NaverMapController? mapController;
  NLatLng? selectedLocation;
  bool isLocationSelected = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '위치 선택',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  NaverMap(
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: widget.initialPosition ??
                            const NLatLng(37.5666805, 126.9784147),
                        zoom: 15,
                      ),
                      extent: NLatLngBounds(
                        southWest: NLatLng(31.43, 122.37),
                        northEast: NLatLng(44.35, 132.0),
                      ),
                      minZoom: 5,
                      maxZoom: 18,
                      indoorEnable: true,
                      locationButtonEnable: true,
                      scrollGesturesEnable: true,
                      zoomGesturesEnable: true,
                      rotationGesturesEnable: true,
                      tiltGesturesEnable: false,
                    ),
                    onMapReady: (controller) {
                      mapController = controller;
                      if (widget.initialPosition != null) {
                        final marker = NMarker(
                          id: 'marker',
                          position: widget.initialPosition!,
                        );
                        controller.addOverlay(marker);
                        setState(() {
                          selectedLocation = widget.initialPosition;
                          isLocationSelected = true;
                        });
                      }
                    },
                    onMapTapped: (point, latLng) {
                      mapController?.clearOverlays();
                      final marker = NMarker(id: 'marker', position: latLng);
                      mapController?.addOverlay(marker);
                      setState(() {
                        selectedLocation = latLng;
                        isLocationSelected = true;
                      });
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: isLocationSelected
                            ? () {
                                widget.onLocationSelected(selectedLocation!);
                                Get.back();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8000),
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '위치 선택 완료',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
