import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:weave_us/controllers/new_join_weave_controller.dart';

class SelectPositionMapView extends GetView<NewJoinWeaveController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          NaverMap(
            onMapTapped: (_ ,latLng) => controller.onMapTap(latLng),
          ),
          Text(controller.closestAreaName.value)
        ],
      );
        });
  }
}