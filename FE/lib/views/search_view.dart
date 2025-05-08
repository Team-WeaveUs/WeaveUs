import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/widgets/search_widgets/map_section.dart';
import 'package:weave_us/views/widgets/search_widgets/recent_search.dart';
import 'package:weave_us/views/widgets/search_widgets/search_result_list.dart';
import 'package:weave_us/views/widgets/search_widgets/search_bar.dart';

import '../controllers/search_controller.dart';
import '../controllers/location_controller.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}


class _SearchViewState extends State<SearchView> {
  final TextEditingController _textSearchController = TextEditingController();
  final LocationController locationController = Get.put(LocationController());
  late final WeaveSearchController _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Get.find<WeaveSearchController>();
  }

  Future<void> _performSearch() async {
    final query = _textSearchController.text.trim();
    if (query.isEmpty) return;

    _viewModel.addRecentSearch(query);
    await _viewModel.search(query);

    if (_viewModel.isShowMap.value) {
      _viewModel.foldMap(); // 지도 반으로 접힘
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '검색'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(
                  textController: _textSearchController,
                  onSearch: _performSearch,
                  searchController: _viewModel,
                ),
                Obx(() =>
                !_viewModel.isShowMap.value
                    ? const RecentSearch()
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() =>
                  _viewModel.isShowMap.value
                      ? const MapSection()
                      : const SearchResultList()),
                ),
                Obx(() {
                  if (locationController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (locationController.error.isNotEmpty) {
                    return Text("에러: ${locationController.error.value}");
                  }

                  final position = locationController.position.value;
                  if (position == null) {
                    return ElevatedButton(
                      onPressed: () => locationController.fetchLocation(),
                      child: Text("현재 위치 가져오기"),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "위도: ${position.latitude}, 경도: ${position.longitude}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 12),
                      if (locationController.closestAreaName.isNotEmpty) ...[
                        Text(
                          "가장 가까운 읍면동: ${locationController.closestAreaName.value}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text("인접 읍면동들:"),
                        ...locationController.neighbors.map(
                              (name) => Text("- $name"),
                        ),
                      ]
                    ],
                  );
                })

              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36, right: 36),
              child: FloatingActionButton(
                onPressed: () {
                  _viewModel.toggleMapView();
                  _viewModel.unfoldMap();
                },
                child: Obx(() =>
                    Icon(
                      _viewModel.isShowMap.value
                          ? HugeIcons.strokeRoundedListView
                          : HugeIcons.strokeRoundedMapsCircle01,
                    )),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}