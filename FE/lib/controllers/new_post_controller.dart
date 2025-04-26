import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../models/create_post_model.dart';
import '../views/widgets/new_post_widgets/delete_image_dialog.dart';

class NewPostController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;
  final isLoading = false.obs;

  NewPostController({required this.apiService, required this.tokenService});

  // 상태관리 변수
  var images = <Uint8List>[].obs;
  var selectedWeaveId = RxnString();
  var selectedWeaveText = ''.obs;
  var tags = <String>[].obs;

  // TextField 상태관리 컨트롤러
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();

  final descriptionText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(() {
      descriptionText.value = descriptionController.text.trim();
    });
  }

  // 게시 가능 여부
  bool get isUploadable =>
      images.isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          selectedWeaveId.value != null;

  // 이미지 선택
  void pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null) {
      for (final image in picked) {
        final bytes = await image.readAsBytes();
        images.add(bytes);
      }
    }
  }

  // 이미지 삭제
  void removeImage(int index) => images.removeAt(index);

  // 위브 선택
  void selectWeave(String weaveId, String weaveName) {
    selectedWeaveId.value = weaveId;
    selectedWeaveText.value = weaveName;
  }

  // Presigned URL 얻기
  Future<String> getPresignedUrl(String fileName) async {
    final token = await tokenService.loadToken();
    final url = Uri.parse(
        "https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/GetPresignedURL");
    final headers = {
      "Content-Type": "application/json",
      "accesstoken": token?.accessToken ?? ""
    };
    final body = jsonEncode({
      "files": [
        {"filename": fileName, "fileType": "image/jpeg"}
      ]
    });
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["body"][0]["presignedUrl"];
    }
    throw Exception("Presigned URL 요청 실패");
  }

  // 이미지 업로드
  Future<void> uploadImage(Uint8List bytes, String fileName) async {
    final url = await getPresignedUrl(fileName);
    final result = await http.put(Uri.parse(url),
        headers: {"Content-Type": "image/jpeg"}, body: bytes);
    if (result.statusCode != 200) throw Exception("이미지 업로드 실패");
  }

  // 게시물 공유 (최종 로직)
  Future<void> sharePost() async {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "게시물을 업로드 중입니다...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }

    try {
      final uploadedFiles = <CreatePostFile>[];
      final userId = await tokenService.loadUserId();

      for (var img in images) {
        final fileName = "post_${const Uuid().v4()}.jpg";
        await uploadImage(img, fileName);
        uploadedFiles.add(CreatePostFile(name: fileName));
      }

      final postPayload = CreatePostRequest(
        userId: userId,
        weaveId: selectedWeaveId.value!,
        content: descriptionController.text,
        files: uploadedFiles,
      );

      final response =
      await apiService.postRequest("PostUpload", postPayload.toJson());

      if (response is Map &&
          (response['statusCode'] == 200 ||
              response['message']?.toString().contains("성공") == true)) {
        Get.back();
        Get.snackbar("성공", "게시물이 등록되었습니다.");

        Get.offAllNamed('/home');
      } else {
        throw Exception("게시물 생성 실패: $response");
      }
    } catch (e) {
      Get.snackbar("오류", "게시물 등록 중 오류 발생: $e");
    }
  }

  // 태그 추가
  void addTag([String? input]) {
    final tagText = tagsController.text.trim();
    if (tagText.isNotEmpty && !tags.contains(tagText)) {
      tags.add(tagText);
      tagsController.clear(); // 입력창 비우기
    }
  }

  // 태그 삭제
  void removeTag(String tag) {
    tags.remove(tag);
  }
  // 컨트롤러 메모리 해제
  @override
  void onClose() {
    descriptionController.dispose();
    tagsController.dispose();
    super.onClose();
  }

  // 다이얼로그 호출하는 함수
  void showDeleteImageDialog() {
    Get.dialog(
      DeleteImageDialog(
        onDelete: () {
          images.clear();
        },
      ),
    );
  }
}