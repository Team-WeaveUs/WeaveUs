import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:weave_us/dialog/weave_dialog.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen/weave_selector.dart';

import 'weave_upload_screen/content_input.dart';
import 'weave_upload_screen/media_widget/media_picker.dart';
import 'weave_upload_screen/media_widget/selected_media_widget.dart';
import 'weave_upload_screen/media_widget/tag_input.dart';
import 'weave_upload_screen/share_button.dart';

class WeaveUploadScreen extends StatefulWidget {
  const WeaveUploadScreen({super.key});

  @override
  State<WeaveUploadScreen> createState() => _WeaveUploadScreenState();
}

class _WeaveUploadScreenState extends State<WeaveUploadScreen> {
  List<String> _selectedFiles = [];
  String? _selectedVideo;
  VideoPlayerController? _videoController;
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];
  String? _selectedWeave;

  // 영상 선택
  void _onVideoSelected(String videoPath) {
    _videoController?.dispose();
    setState(() {
      _selectedVideo = videoPath;
      if (kIsWeb) {
        _videoController = VideoPlayerController.network(videoPath)
          ..initialize().then((_) {
            setState(() {});
          });
      } else {
        _videoController = VideoPlayerController.file(File(videoPath))
          ..initialize().then((_) {
            setState(() {});
          });
      }
    });
  }

  // 이미지 선택
  void _onImagesSelected(List<String> newImages) {
    setState(() {
      _selectedFiles.addAll(newImages);
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
              _selectedWeave = selectedWeave;
            });
          },
        );
      },
    );
  }

  // 공유하기 버튼 스낵바로 클릭 이벤트 로직 생성 1. 사진 또는 영상 없을 때 2. 게시물 내용이 없을 때
  void _onShare() {
    if (_selectedFiles.isEmpty && _selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("사진 또는 영상을 추가해주세요.")),
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("게시물 내용을 입력해주세요.")),
      );
      return;
    }

    // 업로드 기능 추가 가능
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("게시물 공유 완료")),
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
            SelectedMediaWidget(
              selectedFiles: _selectedFiles,
              selectedVideo: _selectedVideo,
              videoController: _videoController,
              onImageRemove: (index) => setState(() => _selectedFiles.removeAt(index)),
              onVideoRemove: () => setState(() {
                _selectedVideo = null;
                _videoController?.dispose();
                _videoController = null;
              }),
              onAddMedia: () => MediaPicker.selectMedia(
                selectedFiles: _selectedFiles,
                selectedVideo: _selectedVideo,
                onVideoSelected: _onVideoSelected,
                onImagesSelected: _onImagesSelected,
                context: context,
              ),
            ),

            const SizedBox(height: 15),
            PostContentInput(controller: _contentController),
            const SizedBox(height: 15),
            TagInput(controller: _tagController, tags: _tags, onTagAdded: _addTag, onTagRemoved: _removeTag),
            const SizedBox(height: 15),
            WeaveSelector(selectedWeave: _selectedWeave, onWeaveSelected: _showWeaveDialog),
            const SizedBox(height: 15),

            ShareButton(onShare: _onShare),
          ],
        ),
      ),
    );
  }
}
