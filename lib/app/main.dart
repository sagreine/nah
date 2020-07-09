import 'package:flutter/material.dart';
import "package:nah/app/state_container.dart";
import 'package:nah/app/login.dart';

// actually use getColor and etc. and decide if negative lifepoints is good or bad haha. 
// // just handle the dismiss direction explicitly on timeline
// add the text protection and etc. to timeline
// perm delete activity on Today or Detail udpates - how?
// FAB on detail page should first Submit text box if active, then add activity..
// capture exception for if they add 2 identical images - ideally when they add the image.
// setup onboarding screens, through settings setup
// enable pick from gallery
// login vertical or horizontal
// remove FAB from Today or do something with it.
///// release

// fancy timelines ---- mostly just up to UI tweaks at this point. -> running totla of lifepoints on left? total used at top?
// fancy flip boxes

// only if we really, really want to:
// better splash screen - see below link
// FAB on edit detail screen.
// add background colors, fonts, etc.
// probably have too much statefulness, more than necessary
// performance profiling for easy wins
// longer term persistence aka DB or even google cloud
// can they put a Gif in, screencap for usual but shows Gif on detail page? would be fun
// actual UI ---  page transitions for one, doesnt look terrible for two -> see e.g. Gridview flutter build below
/// TODO: Sheets:bottom to share/name etc. a day
// https://github.com/flutter/flutter/blob/master/dev/integration_tests/flutter_gallery/lib/demo/material/grid_list_demo.dart
// actually separate files and use a development pattern instead of random nonsense (which is fun while in discovery mode of the language)
// CI / CD

//https://github.com/jogboms/flutter_spinkit
// TODO: better splash screen - https://medium.com/kick-start-fluttering/flutter-design-your-own-splashscreen-d0612b17db23 animate transition? gif?



void main() {
  runApp(new StateContainer(child: new MyApp()));
}
