import 'package:flutter/material.dart';
import 'package:nah/app/home.dart';
import "package:nah/app/state_container.dart";


// order of next things a.k.a. why you should use Jira not comments 
//
// how do we want to deal wtih 3 days at bottom nav bar? add activity, pick activites, today's activities... pageview? manual? UI? - fix bottomnav, no more pop() there.
// fancy timelines ---- mostly just up to UI tweaks at this point.
///// https://pub.dev/packages/timeline_tile
// where does _activities live? singleton? managed by pageview? delete activity
// color palette consistency / more fun logo, e.g. for splash
// better splash screen
// setup onboarding screens, through settings setup
// sliveraninmated list for adding activities? if didn't already for Adding/Editing
// hero uses image as tag....so will crash if they upload multiple of the same image!

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
