import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/widgets/google_map_widget.dart';

import 'components/app_nav_bar.dart';
import 'components/bottom_nav_bar.dart';
import '../controllers/search_controller.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _textSearchController = TextEditingController();
  late final WeaveSearchController _viewModel;

  final RxList<String> _recentSearches = <String>[].obs;

  @override
  void initState() {
    super.initState();
    _viewModel = Get.find<WeaveSearchController>();
  }

  Future<void> _performSearch() async {
    final query = _textSearchController.text.trim();
    if (query.isEmpty) return;

    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query); // 최근 검색에 추가
      if (_recentSearches.length > 10) {
        _recentSearches.removeLast();
      }
    }

    if (_viewModel.isShowMap.value) {
      print("지도 검색 처리: $query");
    } else {
      await _viewModel.search(query);
    }
  }

  void _clearRecentSearches() {
    _recentSearches.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(title: '검색'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 12),
                Obx(() => _viewModel.isShowMap.value
                    ? Expanded(child: GoogleMapWidget())
                    : _buildListSection()),
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              onPressed: _viewModel.toggleMapView,
              child: Obx(() => Icon(
                _viewModel.isShowMap.value
                    ? HugeIcons.strokeRoundedListView
                    : HugeIcons.strokeRoundedMapsCircle01,
              )),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textSearchController,
            decoration: InputDecoration(
              hintText: "@닉네임 또는 제목으로 검색",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onSubmitted: (_) => _performSearch(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _performSearch,
          icon: const Icon(HugeIcons.strokeRoundedSearch02),
        ),
      ],
    );
  }

  Widget _buildListSection() {
    return Expanded(
      child: Obx(() {
        final results = _viewModel.searchResults;

        if (_viewModel.isNoResults.value) {
          return const Center(child: Text("검색 결과가 없습니다."));
        }

        return ListView(
          children: [
            const SizedBox(height: 12),
            const Text("@를 붙여서 친구를 검색할 수 있습니다."),
            const SizedBox(height: 24),
            if (results.isNotEmpty) ...[
              const Text("검색 결과", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...results.map((result) {
                final title = result['title'] ?? result['nickname'] ?? '제목 없음';
                final subtitle = result['description'] ?? result['email'] ?? '';
                return ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  onTap: () {
                    print("클릭한 항목: $title");
                  },
                );
              }).toList(),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("최근 검색", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: const Text("전체 삭제", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Obx(() => _recentSearches.isEmpty
                ? const Text("최근 검색 기록이 없습니다.")
                : Wrap(
              spacing: 8,
              children: _recentSearches.map((term) {
                return ActionChip(
                  label: Text(term),
                  onPressed: () {
                    _textSearchController.text = term;
                    _performSearch();
                  },
                );
              }).toList(),
            )),
            const SizedBox(height: 80),
          ],
        );
      }),
    );
  }
}
