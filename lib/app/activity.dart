import 'package:flutter/material.dart';

// this needs to be better to pass from screen to screen...
class Activity {
  // pls no do this way, btw, if storing in db...
  //https://api.flutter.dev/flutter/widgets/UniqueKey-class.html
  UniqueKey _activityID;

  // these will be set and read
  Image img;
  String title;
  String description;
  int lifepoints = 0;

  Activity(this.img, this.title, this.description, this.lifepoints) {
    _activityID = new UniqueKey();
  }
  // "winsorizes" lifepoints
  int getLifePointsCategory() {
    if (lifepoints < -2) {
      return -3;
    } else if (lifepoints > 2) {
      return 3;
    } else {
      return lifepoints;
    }
  }

  Color getLifePointsColor() {
    switch (getLifePointsCategory()) {
      case -3:
        return Colors.red[300];
      case -2:
        return Colors.red[200];
      case -1:
        return Colors.red[100];
      case 0:
        return Colors.white;
      case 1:
        return Colors.green[100];
      case 2:
        return Colors.green[200];
      case 3:
        return Colors.green[300];
    }
    return Colors.black;
  }
}
