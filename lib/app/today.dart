import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';
import 'package:nah/app/timeline.dart';
import 'package:nah/app/timeline_insert.dart';
import 'package:nah/app/settings.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:nah/app/singletons.dart';


/// TODO: custom timeline rather than reorderable list? more fun :)
/// TODO: animated list? much more fun especially for deletion sweep :)
///

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

