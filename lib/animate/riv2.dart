import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MundoRiveWidget extends StatefulWidget {
  final BoxFit fit;

  const MundoRiveWidget({Key? key, this.fit = BoxFit.cover}) : super(key: key);

  @override
  _MundoRiveWidgetState createState() => _MundoRiveWidgetState();
}

class _MundoRiveWidgetState extends State<MundoRiveWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/animate/logo.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.purple.shade900,
              image: DecorationImage(
                image: AssetImage('assets/images/flutter.png'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
  }
}
