import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../dialog/weave_dialog.dart';

class WeaveUploadScreen extends StatefulWidget {
  const WeaveUploadScreen({super.key});

  @override
  State<WeaveUploadScreen> createState() => _WeaveUploadScreenState();
}

class _WeaveUploadScreenState extends State<WeaveUploadScreen> {
  String? _selectedFile; // 선택된 이미지 파일 저장
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _customController = TextEditingController();
  final List<String> _tags = []; // 태그 리스트
  String? _selectedWeave; // 선택된 위브 데이터

  // 이미지 선택
  Future<void> selectImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first.bytes != null
              ? 'data:image/jpeg;base64,${base64Encode(result.files.first.bytes!)}'
              : result.files.first.path!;
        });
      }
    } else {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1024,
        maxWidth: 1024,
      );

      if (image != null) {
        setState(() {
          _selectedFile = image.path;
        });
      }
    }
  }

  // 태그 추가 기능
  void _addTag(String tag) {
    String formattedTag = tag.startsWith('#') ? tag.trim() : '#${tag.trim()}';
    if (formattedTag.isNotEmpty && !_tags.contains(formattedTag)) {
      setState(() {
        _tags.add(formattedTag);
      });
    }
    _tagController.clear(); // 태그 입력 필드 초기화
  }

  // 태그 삭제 기능
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // 위브 선택 다이얼로그 표시
  void _showWeaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WeaveDialog(
          onWeaveSelected: (selectedWeave) {
            setState(() {
              _selectedWeave = selectedWeave; // 선택된 위브를 상태로 저장
            });
          },
        );
      },
    );
  }

  // 선택된 이미지 위젯
  Widget selectedImageWidget() {
    if (_selectedFile == null) return const SizedBox();

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: kIsWeb
              ? Image.network(
            _selectedFile!,
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
          )
              : Image.file(
            File(_selectedFile!),
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedFile = null;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(60),
              ),
              height: 30,
              width: 30,
              child: Icon(
                Icons.highlight_remove_outlined,
                color: Colors.black.withOpacity(0.6),
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "새 게시물",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.amber[100],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // 스크롤 시 키보드 닫힘
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 이미지 선택 영역
              GestureDetector(
                onTap: selectImage,
                child: Container(
                  width: double.infinity,
                  height: _selectedFile == null ? 180 : 400, // 사진 크기 조절
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedFile == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : selectedImageWidget(),
                ),
              ),
              const SizedBox(height: 8),

              // 게시물 내용 입력
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                ),
                maxLines: null,
              ),

              Divider(height: 20, color: Colors.grey[850], thickness: 0.5),

              // 태그 입력 필드
              Container(
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _tagController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: '# 태그를 입력하세요',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _addTag(value);
                        }
                      },
                    ),

                    Wrap(
                      spacing: 6, // 태그 간격 조정
                      children: _tags
                          .map((tag) => Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => _removeTag(tag),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 20,
                color: Colors.grey[850],
                thickness: 0.5,
              ),

              GestureDetector(
                // onTap: _showWeaveDialog, // 네모칸을 누르면 다이얼로그 표시
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.blue),
                      onPressed: _showWeaveDialog, // 버튼을 눌러도 다이얼로그 표시
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedWeave ?? '위브를 선택해주세요',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  // 생성하기 버튼 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300], // 버튼 배경색
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Center(
                  child: const Text(
                    '공유하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 텍스트 색상
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}