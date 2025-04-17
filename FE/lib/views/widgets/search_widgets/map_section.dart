import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/search_controller.dart';
import 'google_map_widget.dart';
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
            child: const GoogleMapWidget(),
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
