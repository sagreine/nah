import 'package:flutter/material.dart';
import 'package:nah/app/timeline_insert.dart';
import 'package:nah/app/singletons.dart';


/// why do we have this code at all again?

class TodayScreen extends StatefulWidget {
  @override
  TodayScreenState createState() => TodayScreenState();
}

class TodayScreenState extends State<TodayScreen> {
  DayOfActivities thisDay = DayOfActivities();
  
  @override
  Widget build(BuildContext context) {
    

// change this to horizontal only, too easy to mix it up with moving thing.
    Widget viewSection = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: 
          TimelineInsert(),),
        ],      
    );

    return viewSection;
  }
}

