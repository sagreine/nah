import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';

class DetailScreen extends StatelessWidget {
  final Activity activity;

// this.activity was required, but let's not require it for a new on. or pass blank one?
  DetailScreen({Key key, @required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //if (context.)
    Widget fromhero = Hero(
      tag: activity.img,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // doubletap may be inappropriate here, user expecting Tap instead...
          onDoubleTap: () {
            // will want to pass the activity back?
            // or, only if the activity was edited? comparison?
            // need to do hero everywhere to ensure pop back to right place?
            // Navigator.pop(context, activity);
            Navigator.of(context).pop();
          },
          child: activity.img,
        ),
      ),
    );

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                activity.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          RestorativeValWidget(),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

// TODO: what buttons do we actually want, and make them functional
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // what buttons do we even want? delete for sure, but do we need any others?
          _buildButtonColumn(color, Icons.add_circle_outline, 'ADD'),
          _buildButtonColumn(color, Icons.remove_circle_outline, 'REMOVE'),
          _buildButtonColumn(color, Icons.delete_forever, 'DELETE'),
        ],
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      color: activity.getLifePointsColor(),
      child: Text(
        activity.description,
        softWrap: true,
      ),
    );

    Widget viewSection = GestureDetector(
      onPanUpdate: (details) {
        // swipe left to look at today
        if (details.delta.dx < 0) {
          Navigator.of(context).pop();
          /*Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => TodayScreen(selectedActivities: _selectedActivities)),*/
        }
        // should we async await then save? what if they change their mind...
      },
      // the Activities for today...
      // consider function for state.....
      child: ListView(
          children: [
            fromhero,
            // maybe add an edit icon to the image here...
            //trailing: Icon( 
            titleSection,
            buttonSection,
            textSection,
          ],
        ),        
      );


    return MaterialApp(
      title: activity.title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(activity.title),
        ),
        body: viewSection,
      ),
    );
  }

  // builds bottom buttons on edit page..
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class RestorativeValWidget extends StatefulWidget {
  @override
  _RestorativeValWidgetState createState() => _RestorativeValWidgetState();
}

//TODO: editable text...title...etc.... if everything is editable, thinkg state....
//TODO: remove the star or make it an editable wheel or something to change the number.
class _RestorativeValWidgetState extends State<RestorativeValWidget> {
  bool _isRestorative = true;
  int _restorePoints = 2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (_isRestorative ? Icon(Icons.star) : Icon(Icons.star_border)),
            color: (_isRestorative ? Colors.green[500] : Colors.red[500]),
            onPressed: _toggleRestorative,
          ),
        ),
        SizedBox(
            width: 18,
            child: Container(
                child: Text(
                    (_isRestorative ? "+" : "-") + _restorePoints.toString())))
      ],
    );
  }

  void _toggleRestorative() {
    setState(() {
      _isRestorative = !_isRestorative;
    });
  }
}
