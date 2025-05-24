import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/widgets/search_widgets/map_section.dart';

import 'package:weave_us/views/widgets/search_widgets/recent_search.dart';
import 'package:weave_us/views/widgets/search_widgets/search_result_list.dart';
import 'package:weave_us/views/widgets/search_widgets/search_bar.dart';

import '../controllers/search_controller.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}


class _SearchViewState extends State<SearchView> {
  final TextEditingController _textSearchController = TextEditingController();
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

              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36, right: 36),
              child: Obx(() => _viewModel.mapLoading.value ? const CircularProgressIndicator() : FloatingActionButton(
                onPressed: () {
                  _viewModel.toggleMapView();
                  _viewModel.unfoldMap();
                },
                child: Icon(
                      _viewModel.isShowMap.value
                          ? HugeIcons.strokeRoundedListView
                          : HugeIcons.strokeRoundedMapsCircle01,
                    ),
              )),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}