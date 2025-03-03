import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroImage extends StatefulWidget {
  const HeroImage({
    Key? key,
    this.circleRadius = 180.0,
    this.bottom = 50.0,
    this.pauseDuration = const Duration(seconds: 4),
  }) : super(key: key);

  final double circleRadius;
  final double bottom;
  final Duration pauseDuration;

  @override
  _HeroImageState createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/animate/logo.webm')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(false);

        _controller.setVolume(0);
        _controller.play();
        _controller.addListener(_checkVideoEnd);
      });
  }

  void _checkVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      _controller.removeListener(_checkVideoEnd);
      Future.delayed(widget.pauseDuration, () {
        if (mounted) {
          _controller.seekTo(Duration.zero);
          _controller.play();
          _controller.addListener(_checkVideoEnd);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isInitialized
          ? SizedBox(
              width: widget.circleRadius * 2,
              height: widget.circleRadius * 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.circleRadius),
                child: VideoPlayer(_controller),
              ),
            )
          : Container(
              width: widget.circleRadius * 2,
              height: widget.circleRadius * 2,
              decoration: BoxDecoration(
                color: Colors.purple.shade900,
                image: const DecorationImage(
                  image: AssetImage('assets/images/flutter.webp'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
    );
  }
}
