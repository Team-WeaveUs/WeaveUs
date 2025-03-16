import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:weave_us/dialog/weave_dialog.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen/content_input.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen/media_widget/tag_input.dart';
import '../main_screen.dart';
import 'weave_upload_screen/share_button.dart';
import 'weave_upload_screen/weave_selector.dart';

import 'package:weave_us/Auth/api_client.dart';
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

  bool get isUploadable => _selectedFiles.isNotEmpty && _contentController.text.trim().isNotEmpty;

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

  Future<void> _onShare() async {
    if (!isUploadable) {
      return;
    }

    List<Map<String, dynamic>> uploadedFiles = [];

    for (var file in _selectedFiles) {
      print("업로드 시작: ${file["name"]}");
      file["name"] = '${uuid.v4()}.jpg';

      // Presigned URL 요청
      final String? presignedUrl = await _getPresignedUrl(file["name"]);
      if (presignedUrl == null) {
        print("Presigned URL 요청 실패: ${file["name"]}");
        continue; // 업로드 실패 시 건너뜀
      }

      // S3 업로드 수행
      bool uploadSuccess = await _uploadToS3(presignedUrl, file["bytes"]);
      if (!uploadSuccess) {
        print("❌ S3 업로드 실패: ${file["name"]}");
        continue;
      }

      // 업로드 성공 후 리스트에 추가
      uploadedFiles.add({
        "name": file["name"],
        "Type": "image/jpeg",
      });
    }

    // 모든 업로드가 끝난 후 위브 생성 요청
    final response = await ApiService.sendRequest(
      "WeaveAPI/PostUpload",
      {
        "privacy_id": 3,
        "weave_id": _selectedWeaveId,
        "content": _contentController.text,
        "files": uploadedFiles  // ✅ 업로드된 파일 목록 전달
      },
    );

    if (response != null) {
      print("게시물 업로드 성공!");

      // 1초 후 메인 화면으로 이동
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          // print("✅ 업로드 완료 -> main_screen.dart 이동!");
          // Navigator.pushReplacementNamed(context, '/main');
          Get.offAll(() => MainScreen());
        }
      });

      // 스낵바 표시 (mounted 상태 확인 후 실행)
      Future.delayed(Duration.zero, () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("게시물 공유 완료!")),
          );
        }
      });
    } else {
      print("게시물 업로드 실패!");

      // 업로드 실패 시 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("게시물 업로드 실패! 다시 시도해주세요.")),
        );
      }
    }
  }




  // PresignUrl 요청
  Future<String?> _getPresignedUrl(String fileName) async {
    final response = await ApiService.sendRequest(
      "WeaveAPI/GetPresignedURL",
      {
        "files": [
          {
            "filename": fileName,
            "fileType": "image/jpeg"
          }
        ]
      },
    );

    if (response != null && response["body"] is List && response["body"].isNotEmpty) {
      final presignedUrl = response["body"][0]["presignedUrl"];
      print("Presigned URL 성공: $presignedUrl");
      return presignedUrl;
    } else {
      print("Presigned URL 요청 실패");
      return null;
    }
  }

  // S3 업로드 기능
  Future<bool> _uploadToS3(String presignedUrl, Uint8List fileBytes) async {
    try {
      final response = await http.put(
        Uri.parse(presignedUrl),
        headers: {
          "Content-Type": "image/jpeg"
        },
        body: fileBytes,
      );

      if (response.statusCode == 200) {
        print("파일 업로드 성공!");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("게시물 공유 완료!")),
          );

          // 스낵바가 뜬 후 1초 뒤 화면 이동
          await Future.delayed(const Duration(seconds: 1));

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        }

        return true;
      } else {
        print("파일 업로드 실패: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("S3 업로드 오류: $e");
      return false;
    }
  }

  Future<bool> _createWeaveOnServer(
      String title, String description, int typeId, int privacyId, String fileName, Uint8List fileBytes) async {

    // Presigned URL 요청
    final String? presignedUrl = await _getPresignedUrl(fileName);
    if (presignedUrl == null) return false;

    // S3 업로드 수행
    bool uploadSuccess = await _uploadToS3(presignedUrl, fileBytes);
    if (!uploadSuccess) return false;

    // 위브 생성 API 호출
    final response = await ApiService.sendRequest(
      "WeaveAPI/WeaveUpload",
      {
        "title": title,
        "description": description,
        "privacy_id": privacyId,
        "type_id": typeId,
        "image_url": presignedUrl
      },
    );

    if (response != null) {
      debugPrint("위브 생성 성공!");
      return true;
    } else {
      debugPrint("위브 생성 실패!");
      return false;
    }
  }

  // 업로드 s3파일 url생성
  String _getObjectUrl() {
    return "$bucketUrl/$objectKey";
  }

  // 선택 사진 제거
  void _removeImage(int index) {
    print("사진 삭제: ${_selectedFiles[index]["name"]}");
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

            // 사진 추가 & 선택된 사진 미리보기
            Row(
              children: [
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
                const SizedBox(width: 10),

                // 선택된 사진 미리보기 (가로 스크롤)
                Expanded(
                  child: _selectedFiles.isNotEmpty
                      ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_selectedFiles.length, (index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Image.memory(
                                _selectedFiles[index]["bytes"],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _removeImage(index),
                              child: const Icon(Icons.close, color: Colors.black, size: 24),
                            ),
                          ],
                        );
                      }),
                    ),
                  )
                      : Container(),
                ),
              ],
            ),

            const SizedBox(height: 15),

            PostContentInput(
                controller: _contentController),

            const SizedBox(height: 15),
            TagInput(
                controller: _tagController,
                tags: _tags,
                onTagAdded: _addTag,
                onTagRemoved: _removeTag),

            const SizedBox(height: 15),

            WeaveSelector(
                selectedWeave: _selectedWeave,
                onWeaveSelected: _showWeaveDialog),

            const SizedBox(height: 15),

            ShareButton(
              onShare: _onShare,
              isUploadable: isUploadable,
            ),
          ],
        ),
      ),
    );
  }
}