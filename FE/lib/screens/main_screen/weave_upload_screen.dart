import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:weave_us/dialog/weave_dialog.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen/content_input.dart';
import '../../dialog/delete_image_dialog.dart';
import '../main_screen.dart';
import 'weave_upload_screen/s3_serivce.dart';
import 'weave_upload_screen/share_button.dart';
import 'weave_upload_screen/weave_selector.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'package:weave_us/Auth/api_client.dart';

class WeaveUploadScreen extends StatefulWidget {
  const WeaveUploadScreen({super.key});

  @override
  State<WeaveUploadScreen> createState() => _WeaveUploadScreenState();
}

class _WeaveUploadScreenState extends State<WeaveUploadScreen> {
  final S3Service _s3Service = S3Service();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final uuid = Uuid();
  final List<String> _tags = [];

  List<Map<String, dynamic>> _selectedFiles = [];
  String? _selectedWeave;
  int? _selectedWeaveId;

  bool get isUploadable =>
      _selectedFiles.isNotEmpty && _contentController.text.trim().isNotEmpty;

  late double _distanceToField;
  late StringTagController _stringTagController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController();
  }

  @override
  void dispose() {
    super.dispose();
    _stringTagController.dispose();
  }

  static const List<String> _initialTags = <String>[
    'c',
    'c++',
    'java',
    'json',
    'python',
    'javascript',
  ];

  // 이미지 선택
  void _pickImages() {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = "image/jpeg, image/jpg";
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null) {
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoadEnd.listen((_) {
            Uint8List bytes = reader.result as Uint8List;
            setState(() {
              _selectedFiles.add({"name": file.name, "bytes": bytes});
            });
            print("선택된 파일: ${file.name}");
          });
        }
      }
    });
  }

  // 업로드 버튼 클릭 시 실행
  Future<void> _onShare() async {
    if (!isUploadable) {
      return;
    }

    bool success = await _s3Service.uploadFilesAndSendToServer(
        _selectedFiles, _contentController.text, _selectedWeaveId);

    if (success) {
      print("게시물 업로드 성공!");
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Get.offAll(() => MainScreen());
        }
      });
      Future.delayed(Duration.zero, () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("게시물 공유 완료!")),
          );
        }
      });
    } else {
      print("게시물 업로드 실패!");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("게시물 업로드 실패! 다시 시도해주세요.")),
        );
      }
    }
  }

  // 위브 선택 다이얼로그 표시
  void _showWeaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WeaveDialog(
          onWeaveSelected: (selectedWeave) {
            setState(() {
              _selectedWeave = selectedWeave.split(",")[0];
              _selectedWeaveId = int.tryParse(selectedWeave.split(",")[1]);
            });
          },
        );
      },
    );
  }

  // 다이얼로그 호출하는 함수
  void _showDeleteImageDialog() {
    Get.dialog(
      DeleteImageDialog(
        onDelete: () {
          setState(() {
            _selectedFiles.clear();
          });
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: const Text("새 게시물",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: 25
              )),
        ),
        backgroundColor: Colors.white, // 앱바 배경색
        centerTitle: true, // 앱바 타이틀 중앙
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey[850], thickness: 1, indent: 0, endIndent: 0,),
            // 위브 선택
            WeaveSelector(selectedWeave: _selectedWeave, onWeaveSelected: _showWeaveDialog),
            Divider(color: Colors.grey[850], thickness: 0.5, indent: 0, endIndent: 0,),
            // 사진 추가
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_selectedFiles.isNotEmpty) {
                          _showDeleteImageDialog(); // ✅ 삭제 다이얼로그 띄우기
                        } else {
                          _pickImages(); // ✅ 사진 선택
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _selectedFiles.isEmpty
                            ? Center(
                          child: Image.asset(
                            'assets/image/picture_upload.png',
                            height: 150,
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _selectedFiles[0]["bytes"],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey[850], thickness: 0.5, indent: 0, endIndent: 0,),
            // 게시물 내용
            PostContentInput(controller: _contentController),
            Divider(color: Colors.grey[850], thickness: 0.5, indent: 0, endIndent: 0,),
            // 태그
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Autocomplete<String>(
                    optionsViewBuilder: (context, onSelected, options) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Material(
                            elevation: 4.0,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context,
                                    int index) {
                                  final String option = options.elementAt(
                                      index);
                                  return TextButton(
                                    onPressed: () {
                                      onSelected(option);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '#$option',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 74, 137, 92),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return _initialTags.where((String option) {
                        return option.contains(
                            textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selectedTag) {
                      _stringTagController.onTagSubmitted(selectedTag);
                    },
                    fieldViewBuilder: (context, textEditingController,
                        focusNode,
                        onFieldSubmitted) {
                      return TextFieldTags<String>(
                        textEditingController: textEditingController,
                        focusNode: focusNode,
                        textfieldTagsController: _stringTagController,
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (tag == 'php') {
                            return 'No, please just no';
                          } else
                          if (_stringTagController.getTags!.contains(tag)) {
                            return '이미 추가된 태그입니다!';
                          }
                          return null;
                        },
                        inputFieldBuilder: (context, inputFieldValues) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: inputFieldValues
                                  .textEditingController,
                              focusNode: inputFieldValues.focusNode,
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,

                                hintText: inputFieldValues.tags.isNotEmpty
                                    ? '# 태그'
                                    : "# 태그",
                                errorText: inputFieldValues.error,
                                prefixIconConstraints:
                                BoxConstraints(
                                    maxWidth: _distanceToField * 1),
                                prefixIcon: inputFieldValues.tags.isNotEmpty
                                    ? SingleChildScrollView(
                                  controller:
                                  inputFieldValues.tagScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: inputFieldValues.tags
                                          .map((String tag) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            color: Color.fromARGB(
                                                255, 133, 132, 130),
                                          ),
                                          margin:
                                          const EdgeInsets.only(right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                              vertical: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  '#$tag',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    letterSpacing: 1,),
                                                ),
                                                onTap: () {
                                                  //print("$tag selected");
                                                },
                                              ),
                                              const SizedBox(width: 4.0),
                                              InkWell(
                                                child: const Icon(
                                                  Icons.cancel,
                                                  size: 14.0,
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                ),
                                                onTap: () {
                                                  inputFieldValues
                                                      .onTagRemoved(tag);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                )
                                    : null,
                              ),
                              onChanged: inputFieldValues.onTagChanged,
                              onSubmitted: inputFieldValues.onTagSubmitted,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            // 공유 버튼
            ShareButton(onShare: _onShare, isUploadable: isUploadable),
          ],
        ),
      ),
    );
  }
}
