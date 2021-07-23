import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Video extends StatefulWidget {
  final String _path;

  Video(this._path);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  VideoPlayerController _artController;

  @override
  void initState() {
    _artController = VideoPlayerController.network(
      '${dotenv.env['IP_ADDRESS']}/${widget._path}',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    ) ..addListener(() => setState((){}))
      ..setLooping(false)
      ..initialize().then(
        (_) async {
          await _artController.setVolume(0.0);
          //await _artController.setPlaybackSpeed(1.2);
          await _artController.play();
          setState(() {});
        },
      );
    super.initState();
  }

  @override
  Future<void> dispose() async {
    await _artController.dispose();
    _artController.removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${Random.secure()}'),
      onVisibilityChanged: (value) async {
        var v = value.visibleFraction * 100;
        if (v == 100) {
          _artController.play();
        } else {
          _artController.pause ( );
          _artController.seekTo(Duration.zero);
        }
      },
      child:_artController.value.isInitialized ? AspectRatio(
        aspectRatio: _artController.value.aspectRatio,
        child: new VideoPlayer(_artController),
      ): Container()
    );
  }
}
