
import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';

///// needs to be a list, not a set, as activities can repeat here
/// needs order-ability
/// 
class TodayScreen extends StatefulWidget {
    @override
  TodayScreenState createState() => TodayScreenState();
}


class TodayScreenState extends State<TodayScreen> {

  final List<Activity> _activities = List<Activity>();
  List<Activity> selectedActivities = List<Activity>();

  //TodayScreenState({Key key, @required this.selectedActivities}) ;//: super(key: key);



  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        body: Text("this is a new page"),
      )
    );
  }
}

//animated liist?
/*
    Widget todaySection() {
      return ListView.builder(itemBuilder: (context, i) {
        return ListTile(
          title: Text(
            _selectedActivities[i].title,
          ),
        );
      });
    }
    */