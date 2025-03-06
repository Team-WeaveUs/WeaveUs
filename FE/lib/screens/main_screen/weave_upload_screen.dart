import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/dialog/weave_dialog.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen/content_input.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen/media_widget/tag_input.dart';
import 'dart:convert';

import '../../Auth/token_storage.dart';
import 'weave_upload_screen/share_button.dart';
import 'weave_upload_screen/weave_selector.dart';

import 'package:weave_us/Auth/api_client.dart';
import 'weave_upload_screen/media_widget/tag_input.dart';
import 'weave_upload_screen/content_input.dart';
import 'weave_upload_screen/media_widget/media_picker.dart';
import 'weave_upload_screen/media_widget/selected_media_widget.dart';

class WeaveUploadScreen extends StatefulWidget {
  const WeaveUploadScreen({super.key});

  @override
  State<WeaveUploadScreen> createState() => _WeaveUploadScreenState();
}


class _WeaveUploadScreenState extends State<WeaveUploadScreen> {
  List<Map<String, dynamic>> _selectedFiles = [];
  final TextEditingController _contentController = TextEditingController();
  final uuid = Uuid();
  final String bucketUrl = "https://weave-bucket.s3.ap-northeast-2.amazonaws.com";
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  String objectKey = '';
  String? _selectedWeave;
  int? _selectedWeaveId;

  /// 사진 & 글이 있는지 여부 체크
  bool get isUploadable => _selectedFiles.isNotEmpty && _contentController.text.trim().isNotEmpty;

  /// 📂 **웹에서 파일 선택 (jpg, jpeg만 허용)**
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
            print("✅ 선택된 파일: ${file.name}");
          });
        }
      }
    });
  }

  /// 📩 **공유하기 버튼 클릭 시 실행**
  Future<void> _onShare() async {
    if (!isUploadable) {
      print("🚨 사진과 글을 입력하세요! 🚨");
      return;
    }

    for (var file in _selectedFiles) {
      print("📤 업로드 시작: ${file["name"]}");
      file["name"] = '${uuid.v4()}.jpg';
      _uploadToS3(file["name"], file["bytes"]);
      file.remove("bytes");
      file["Type"] = "image/jpeg";
    }


    print("✅ 업로드 완ddddddddddd료 ${_selectedFiles}");

    print("✅ 업로드 완dfsafddas료 -> ${_contentController.text}");

    final response = await ApiService.sendRequest(
      "WeaveAPI/PostUpload",
      {
        "privacy_id": 3,
        "weave_id":_selectedWeaveId,
        "content":_contentController.text,
        "files": _selectedFiles
      }, // 🔥 검색어 전송
    );


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("📤 게시물 공유 완료!")),
    );

    // ✅ 업로드 후 1초 뒤 main_screen.dart로 이동
    Future.delayed(const Duration(seconds: 1), () {
      print("✅ 업로드 완료 -> main_screen.dart 이동!");
      Navigator.pushReplacementNamed(context, '/main');
    });
  }


  /// 📜 **Presigned URL 요청**
  Future<String?> _getPresignedUrl(String fileName) async {
    String? accessToken = await TokenStorage.getAccessToken();

    final String uniqueFilename = fileName;
    final String contentType = 'image/jpeg';
    final String apiUrl =
        'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/GetPresignedURL';

    final headers = {
      "accesstoken": "$accessToken",
      "Content-Type": "application/json"
    };

    final requestBody = {

      "files": [
        {
          "filename": uniqueFilename,
          "fileType": contentType,
        }
      ]
    };


    print("🔄 Presigned URL 요청 중...");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print("🟢 Presigned URL 응답 코드: ${response.statusCode}");
      print("🔹 Presigned URL 응답 바디: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final presignedUrl = responseData["body"][0]["presignedUrl"];
        // setState(() {
        //   objectKey = uniqueFilename;
        // });
        print("✅ Presigned URL 성공: $presignedUrl");
        return presignedUrl;
      } else {
        print("❌ Presigned URL 요청 실패: ${response.body}");
      }
    } catch (e) {
      print("❌ Presigned URL 요청 오류: $e");
    }
    return null;
  }

  /// 📤 **S3 업로드 기능**
  Future<void> _uploadToS3(String fileName, Uint8List fileBytes) async {
    final presignedUrl = await _getPresignedUrl(fileName);
    if (presignedUrl == null) {
      print("❌ Presigned URL이 없습니다. 업로드 중단");
      return;
    }

    print("🔄 S3 업로드 시작: $presignedUrl");

    try {
      final response = await http.put(
        Uri.parse(presignedUrl),
        headers: {
          "Content-Type": "image/jpeg"
        },
        body: fileBytes,
      );

      print("🟢 S3 업로드 응답 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("✅ 파일 업로드 성공: ${_getObjectUrl()}");
      } else {
        print("❌ 파일 업로드 실패: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ S3 업로드 오류: $e");
    }
  }

  /// 📌 **업로드된 S3 파일 URL 생성**
  String _getObjectUrl() {
    return "$bucketUrl/$objectKey";
  }

  /// 🖼️ **선택된 사진 삭제 기능**
  void _removeImage(int index) {
    print("🗑️ 사진 삭제: ${_selectedFiles[index]["name"]}");
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  // 태그 추가 기능
  void _addTag(String tag) {
    setState(() {
      _tags.add(tag.startsWith('#') ? tag.trim() : '#${tag.trim()}');
    });
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
              _selectedWeave = selectedWeave.split(",")[0];
              _selectedWeaveId = int.tryParse(selectedWeave.split(",")[1]);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("새 게시물")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 📸 사진 추가 아이콘 & 선택된 사진 미리보기
            Row(
              children: [
                // 사진 추가 버튼 (최대 9장)
                if (_selectedFiles.length < 9)
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.add_a_photo, size: 40, color: Colors.black54),
                      ),
                    ),
                  ),

                const SizedBox(width: 10), // 아이콘과 사진 사이 간격

                // 선택된 사진 미리보기 (가로 스크롤 적용)
                Expanded(
                  child: _selectedFiles.isNotEmpty
                      ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // 가로 스크롤
                    child: Row(
                      children: List.generate(_selectedFiles.length, (index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10), // 사진 간격 유지
                              child: Image.memory(
                                _selectedFiles[index]["bytes"],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _removeImage(index),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  )
                      : Container(), // 빈 상태일 때 차지하는 공간 없음
                ),
              ],
            ),

            const SizedBox(height: 15),
            PostContentInput(controller: _contentController),
            const SizedBox(height: 15),
            TagInput(controller: _tagController, tags: _tags, onTagAdded: _addTag, onTagRemoved: _removeTag),
            const SizedBox(height: 15),
            WeaveSelector(selectedWeave: _selectedWeave, onWeaveSelected: _showWeaveDialog),
            const SizedBox(height: 15),
            ShareButton(onShare: _onShare, isUploadable: isUploadable),
          ],
        ),
      ),
    );
  }
}