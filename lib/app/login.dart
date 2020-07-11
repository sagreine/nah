import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nah/app/onboarding.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';



// borrowed here: https://github.com/syonip/flutter_login_video/blob/master/lib/sign_in.dart
// and here: https://medium.com/@KarthikPonnam/flutter-pageview-withbottomnavigationbar-fb4c87580f6a
// will separate Login and home page...
class MyApp extends StatelessWidget {
  @override
  //MyAppState createState() => MyAppState();
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLogin()      
      );
  }
}

class MyLogin extends StatefulWidget {
  MyLogin({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // login screen -> up and down only.
    // could play the waterfall vid on landscape instead :0
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset("assets/videos/science2.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.setVolume(0);
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
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 65),
        width: double.infinity,
        child: Container(
          color: Colors.blueAccent,
          child: Container(            
            width: double.infinity,
            height: 75,
            alignment: Alignment.center,
            child: FlatButton(
            child: Text("Let's do this. Or, you know, not ;)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),

          onPressed: () {
            // so this would change if we needed to verify login...

            // essentially, go back to auto mode after this...
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);

            // close if you back out after logging in
            // right now just avoids video running issues on login page (running after logged in)
            // dispose, but then no video on back. otherwise, video runs in background
            // easy to fix but ... why
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (BuildContext context) {
                return Scaffold(
                  body: Container(child: Splash()),
                );
              }),
            );
          },          
        ),
        ),
      ),
      ),
    ];
  }
}