
import 'package:nah/app/activity.dart';

class DayOfActivities {
  //extends ExampleStateBase {
  static final DayOfActivities _instance = DayOfActivities._internal();

  List<Activity> activities;

  //int currentScore;

  factory DayOfActivities() {
    return _instance;
  }

  int getLifePointsSum() {
    int tmp = 0;
    activities.forEach((element) {
      tmp += element.lifepoints;
    });
    return tmp;
  }

  DayOfActivities._internal() {
    activities = List<Activity>();
  }
}

// Singleton for the day. trying it out. not sure why it is in this file though.
class AllActivities {
  //extends ExampleStateBase {
  static final AllActivities _instance = AllActivities._internal();

  List<Activity> activities;

  //int currentScore;

  factory AllActivities() {
    return _instance;
  }

  AllActivities._internal() {
    activities = List<Activity>();
  }
}