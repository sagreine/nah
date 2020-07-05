import 'package:flutter/material.dart';


class Activity {
  // pls no do this way, btw, if storing in db...
  //https://api.flutter.dev/flutter/widgets/UniqueKey-class.html
  // also
  final UniqueKey activityID = new UniqueKey();
  // these will be set and read
  String imgPath;
  String title;
  String subtitle;
  String description;
  int lifepoints = 0;

  Activity(this.imgPath, this.title, this.subtitle, this.description, this.lifepoints) {
    //activityID = 
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
        return Colors.red[600];
      case -2:
        return Colors.red[400];
      case -1:
        return Colors.red[200];
      case 0:
        return Colors.white;
      case 1:
        return Colors.green[200];
      case 2:
        return Colors.green[400];
      case 3:
        return Colors.green[600];
    }
    return Colors.black;
  }
}
