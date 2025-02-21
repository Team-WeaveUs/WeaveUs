import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SelectedMediaWidget extends StatelessWidget {
  final List<String> selectedFiles;
  final String? selectedVideo;
  final VideoPlayerController? videoController;
  final Function(int) onImageRemove;
  final VoidCallback onVideoRemove;
  final VoidCallback onAddMedia;

  const SelectedMediaWidget({
    super.key,
    required this.selectedFiles,
    this.selectedVideo,
    this.videoController,
    required this.onImageRemove,
    required this.onVideoRemove,
    required this.onAddMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 영상 미리보기 ( ※ 수정 예정 )
        if (selectedVideo != null && videoController != null)
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // 전체 너비의 80%로 설정
                height: MediaQuery.of(context).size.width * 0.45, // 16:9 비율 유지
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: VideoPlayer(videoController!),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: onVideoRemove,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    height: 30,
                    width: 30,
                    child: const Icon(Icons.close, color: Colors.black, size: 25),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),

        // 이미지 UI 추가
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
          itemCount: selectedFiles.length + (selectedFiles.length < 9 ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == selectedFiles.length && selectedFiles.length < 9) {
              return GestureDetector(
                onTap: onAddMedia,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_a_photo, size: 40, color: Colors.black54),
                  ),
                ),
              );
            }

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: kIsWeb && selectedFiles[index].startsWith('data:image')
                      ? Image.network(selectedFiles[index])
                      : Image.file(File(selectedFiles[index]), fit: BoxFit.cover),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => onImageRemove(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      height: 25,
                      width: 25,
                      child: const Icon(Icons.close, color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
