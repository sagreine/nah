import 'package:flutter/material.dart';
import 'package:nah/app/home.dart';
import "package:nah/app/state_container.dart";


// order of next things a.k.a. why you should use Jira not comments 
// determine with finality overall approach below. -> approach 1 per users vai wireframe + walkthrough - done (for now :))
//
// nice to have, post-MVP below
//
// make adding an activity work, editable activity if it is easy too
// look into persistence, simple way first, across 1 day of use at least
// fancy timelines
// navbar and re-nav'ing -> no button, just bottomNav 
// editable activity
// color palette consistency / more fun logo, e.g. for splash
// better splash screen
// setup onboarding screens, through settings setup
// sliveraninmated list for adding activities? if didn't already for Adding/Editing
// actually separate files and use a development pattern instead of random nonsense (which is fun while in discovery mode of the language)
// longer term persistence aka DB or even google cloud
// actual UI ---  page transitions for one, doesnt look terrible for two -> see e.g. Gridview flutter buil
// https://github.com/flutter/flutter/blob/master/dev/integration_tests/flutter_gallery/lib/demo/material/grid_list_demo.dart
// release, testing, CI, CD


// TODO: actually consider statefulness.....
// TODO: pick color pallete, make that theme, no more hex
// TODO: bottom nav bar or Appbar, to all pages
// TODO: better splash screen - https://medium.com/kick-start-fluttering/flutter-design-your-own-splashscreen-d0612b17db23 animate transition? gif?
// TODO: 'remove from Today screen' option to get rid of an item right there
/// TODO: allow to temporarily override lifepoints
/// TODO: Sheets:bottom to share/name etc. a day
/// TODO: make settings not ugly as all get out
/// TODO: do we want it to be, auto updates today's screen? or make them press a button to add to it...
/// 
/// option 1) start on list page. select ones to add. button to add them. toast success. go to right to see today's list, back to left to add things
/// pro: can click things, check out the order + # times you're doing something, change your mind
/// con: you HAVE to swipe back and forth if you want to see what's selected today already (you'd blank out today's list on List once add button pressed)
/// e.g., did I already add that? lemme swipe back to check....
/// option 2) as soon as you click, add to today. 
/// pro: things are completely in synce which is nice
/// con: have to give them an opportunity to add multiple of same activity somewhere... 
/// con: if that's Today screen, need to give them add/remove func. there and associated error checking which is a hassle.
/// con: no use for add button, which is not a con of course. 
/// con: a little more intuitive to say "add these!" than just know they're there --- i'd wonder why i need to go to a second screen at all, honestly..
/// if all it adds is ability to reorder and view in a pretty timeline.
/// 
/// okay, final(ish) decision is in -> option 1 has been selected by users. will add "remove from list" on Today screen as a feature
/// 
/// TODO: redo them as listTiles... just easier that way.. -> nope, too small to look at :(. but maybe we just replace with icons in the end...
/// TODO: add a first time setup tutorial, just for fun!


void main() {
  runApp(new StateContainer(child: new MyApp()));
}
