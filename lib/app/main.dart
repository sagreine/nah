import 'package:flutter/material.dart';
import 'package:nah/app/home.dart';

// TODO: actually consider statefulness.....
// TODO: pick color pallete, make that theme, no more hex
// TODO: settings page
// TODO: bottom nav bar or Appbar, to all pages
// TODO: better splash screen - https://medium.com/kick-start-fluttering/flutter-design-your-own-splashscreen-d0612b17db23 animate transition? gif?
/// TODO: do we want it to be, auto updates today's screen? or make them press a button to add to it...
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
/// TODO: redo them as listTiles... just easier that way.. -> too small to look at :(
/// TODO: add a first time setup tutorial, just for fun.


void main() {
  runApp(MyApp());
}
