import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../models/weave_data_model.dart';

class MapService extends GetxService {
  final markers = <NMarker>{}.obs;
  final selectedLatLng = Rxn<NLatLng>();

  void setMarkers(List<JoinWeave> groups) {
    markers.assignAll(groups.map((group) {
      return NMarker(
        id: group.weaveId.toString(),
        position: NLatLng(group.lat, group.lng),
      );
    }));
  }

  void clearMarkers() => markers.clear();

  void setSelectedPosition(NLatLng latLng) {
    selectedLatLng.value = latLng;
  }

  void clearSelectedPosition() => selectedLatLng.value = null;
}
