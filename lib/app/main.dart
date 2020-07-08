import 'package:flutter/material.dart';
import "package:nah/app/state_container.dart";
import 'package:nah/app/login.dart';


// order of next things a.k.a. why you should use Jira not comments 
// when update an activity -> setState isn't effectively called on List
// when you start on Add Activity and add it and navigate via FAB, list screen isn't initialized for some reason?
// fix the edit activity page that jumps when editing text

// perm delete activity on Today or Detail udpates - how?
// color palette consistency / more fun logo, e.g. for splash
// better splash screen
// setup onboarding screens, through settings setup
// sliveraninmated list for adding activities? if didn't already for Adding/Editing
// hero uses image as tag....so will crash if they upload multiple of the same image!
///// for now we just don't let them look at details from that page..

// actually use getColor and etc. and decide if negative lifepoints is good or bad haha. 
// fancy timelines ---- mostly just up to UI tweaks at this point. -> running totla of lifepoints on left? total used at top?

// longer term persistence aka DB or even google cloud
// can they put a Gif in, screencap for usual but shows Gif on detail page? would be fun
// actual UI ---  page transitions for one, doesnt look terrible for two -> see e.g. Gridview flutter build below
// https://github.com/flutter/flutter/blob/master/dev/integration_tests/flutter_gallery/lib/demo/material/grid_list_demo.dart
// maybe a gridTile and gridTileBar? better than a custom stack kprobably..
// actually separate files and use a development pattern instead of random nonsense (which is fun while in discovery mode of the language)
// release, testing, CI, CD
//https://github.com/jogboms/flutter_spinkit


// TODO: actually consider statefulness.....
// TODO: pick color pallete, make that theme, no more hex
// TODO: better splash screen - https://medium.com/kick-start-fluttering/flutter-design-your-own-splashscreen-d0612b17db23 animate transition? gif?
/// TODO: allow to temporarily override lifepoints
/// TODO: Sheets:bottom to share/name etc. a day
/// TODO: make settings not ugly as all get out
/// 
/// TODO: redo them as listTiles... just easier that way.. -> nope, too small to look at :(. but maybe we just replace with icons in the end...
/// TODO: add a first time setup tutorial, just for fun!


void main() {
  runApp(new StateContainer(child: new MyApp()));
}
