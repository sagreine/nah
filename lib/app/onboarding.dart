import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nah/app/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';

//https://stackoverflow.com/questions/50654195/flutter-one-time-intro-screen
class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // update this for debugging...
    bool _seen =
        //false;
        (prefs.getBool('seen') ?? false);

    if (_seen) {
      return MyHome.id;
    } else {
      // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
      //await prefs.setBool('seen', true);
      return IntroScreen.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return MaterialApp(
              initialRoute: snapshot.data,
              routes: {
                IntroScreen.id: (context) => IntroScreen(),
                MyHome.id: (context) => MyHome(),
              },
            );
          }
        });
  }
}

class IntroScreen extends StatelessWidget {
  static String id = 'IntroScreen';

  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      decoration: const PageDecoration(
        boxDecoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFCCCA9),
              Color(0xFFFFA278),
            ],
          ),
        ),
      ),
      title: "Start with a little setup",
      body:
          "Each activity takes life energy (positive) or gives it back (negative). You pick how many lifepoints you have to spend in a day, and pick what activities you want and in what order.",
      image: Center(child: Image.asset('assets/images/settings.jpg')),
      footer: RaisedButton(
        onPressed: () {
          // On button presed
        },
        child: const Text("Let's Go !"),
      ),
    ),
    PageViewModel(
      decoration: const PageDecoration(
        boxDecoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFd7fada),
              Color(0xFFFFa7f2ae),
            ],
          ),
        ),
      ),
      title: "Add the activities you might ever do",
      body:
          "We've preloaded some activities for you. You can add your own by clicking Create Activity or edit ours by double tapping from the Pick activities page. Double tap anytime for details.",
      image: Center(child: Image.asset('assets/images/construction.jpg')),
      footer: RaisedButton(
        onPressed: () {
          // On button presed
        },
        child: const Text("Let's Go !"),
      ),
    ),
    PageViewModel(
      decoration: const PageDecoration(
        boxDecoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFc6e8f5),
              Color(0xFFFF65cff7),
            ],
          ),
        ),
      ),
      title:
          "Once you have activities you might do in a day, pick the ones you want to do today",
      body:
          "Once you've added some activities, single tap on activities you want to do today. Add them to your day using the main button on the page.",
      image: Center(child: Image.asset('assets/images/yourday.jpg')),
      footer: RaisedButton(
        onPressed: () {
          // On button presed
        },
        child: const Text("Let's Go !"),
      ),
    ),
    PageViewModel(
      decoration: const PageDecoration(
        boxDecoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFd3bbf2),
              Color(0xFFFFc7a4f5),
            ],
          ),
        ),
      ),
      title: "View and rearrange your day",
      body:
          "Long press and drag to rearrange, or swipe to remove. You can always add more to the day by going back to the list page!",
      image: Center(child: Image.asset('assets/images/organize.jpg')),
      footer: RaisedButton(
        onPressed: () {
          // On button presed
        },
        child: const Text("Let's Go !"),
      ),
    ),
  ];

  void _markPrefsDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: IntroductionScreen(
        pages: listPagesViewModel,
        onDone: () {
          _markPrefsDone();
          //return MyHome.id: (context) => MyHome()
          //Route()
          // When done button is press
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Scaffold(
                body: Container(child: MyHome()),
              );
            }),
          ); //initialRoute: snapshot.data
        },
        //onSkip: () {
        // You can also override onSkip callback
        //},
        showSkipButton: true,
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.arrow_right),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.blue.withAlpha(120),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
