import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;
  final Function(String) onSearch;

  const SearchInput({
    Key? key,
    required this.searchController,
    required this.focusNode,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: searchController,
        focusNode: focusNode,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: "예: 위브, @weave, #방문 검색",
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}