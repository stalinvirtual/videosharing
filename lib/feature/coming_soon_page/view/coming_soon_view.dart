import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ComingSoonPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeeksForGeeks',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );
    _initializeVideoPlayerFuture = _controller!.initialize();
    final desiredPosition = Duration(seconds: 3);
    _controller!.seekTo(desiredPosition);
    //_controller!.setLooping(true);
    _controller!.addListener(() {
      print("#### position ###");
      print(_controller!.value.position);
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GeeksForGeeks'),
          backgroundColor: Colors.green,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                      Slider(
                        value: _controller!.value.position.inSeconds.toDouble(),
                        min: 0.0,
                        max: _controller!.value.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          final newPosition = Duration(seconds: value.toInt());
                          _controller!.seekTo(newPosition);
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  // pause
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    // play
                    _controller!.play();
                  }
                });
              },
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ],
        ));
  }
}
