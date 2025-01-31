import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSection extends StatefulWidget {
  const VideoSection({super.key});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Ejemplo: si detectas web, quizás usar network, si no, asset
    _videoController = VideoPlayerController.asset('assets/videos/slide.mp4')
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _isInitialized
          ? VideoPlayer(_videoController)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
