import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_project/Screens/init_splash.dart';
import 'package:video_player/video_player.dart';

/*
Intro video for an app
*/

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(
      'assets/images/SS3.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    setState(() {
      _controller.play();
    });
    _controller.setLooping(true);
    _controller.initialize();
    Timer(const Duration(seconds: 5), () async {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InitSplash(),
          ),
          (route) => false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: VideoPlayer(_controller),
      ),
    );
  }
}
