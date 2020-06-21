import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nah/app/list.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

// or just put this in main.....

// borrowed here: https://github.com/syonip/flutter_login_video/blob/master/lib/sign_in.dart

//TODO: fix it so back button doesn't break it but video stops once leaving..
class MyApp extends StatelessWidget {
  @override
  //MyAppState createState() => MyAppState();
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key, key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
// this might not be a good idea, need to update every other tab....
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]
    );

    _controller = VideoPlayerController.asset("assets/videos/science2.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              _getVideoBackground(),
              _getBackgroundColor(),
              _getContent(),
            ],
          ),
        ),
      ),
    );
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }

  _getBackgroundColor() {
    return Container(
      color: Colors.blue.withAlpha(120),
    );
  }

  _getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 50.0,
        ),
        Image(
          image: AssetImage("assets/images/ic_launcher.png"),
          width: 150.0,
        ),
        Text(
          "nah",
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
          alignment: Alignment.center,
          child: Text(
            "do less, be happier",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Spacer(),
        ..._getLoginButtons()
      ],
    );
  }

  _getLoginButtons() {
    return <Widget>[      
      Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 45),
        width: double.infinity,
        child: FlatButton(
          color: Colors.blueAccent,
          padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
          child: const Text(
            'Log in',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (BuildContext context) {
                return Scaffold(
                  body: Container(child: ListScreen()),
                );
              }),
            );
            // this is a bad hack.
           _controller.setVolume(0);
          },
        ),
      ),
    ];
  }
}
