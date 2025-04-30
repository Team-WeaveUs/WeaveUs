import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class WeaveDialogController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ApiService apiService;

  WeaveDialogController({required this.apiService});

  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var hasSearched = false.obs;

  late Worker _debouncer;

  @override
  void onInit() {
    super.onInit();

    _debouncer = debounce(
      searchController.text.obs,
          (_) => fetchSearchResults(),
      time: const Duration(milliseconds: 500),
    );

    searchController.addListener(() {
      hasSearched.value = true;
    });
  }

  Future<void> fetchSearchResults() async {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiService.postRequest("search/weave", {
        'title': query,
      });

      if (response != null && response['weaves'] is List) {
        searchResults.value = List<Map<String, dynamic>>.from(response['weaves']);
      } else {
        searchResults.clear();
      }
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    _debouncer.dispose();
    super.onClose();
  }
}