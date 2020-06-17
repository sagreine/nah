import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';

class DetailScreen extends StatelessWidget {
  final Activity activity;
  DetailScreen({Key key, @required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    activity.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //if(_activities[0].lifepoints > 0)
                //{
              ],
            ),
          ),
          // this is not right of course. applies to wrong 'page'..
          RestorativeValWidget(),
        ],
      ),
    );

  Color color = Theme.of(context).primaryColor;

  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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

    return MaterialApp(
      title: 'Detail for ' + activity.title,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detail for ' + activity.title),
        ),
        body: ListView(
          children: [
            activity.img,
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
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

// these will be heroanimation eventually
class RestorativeValWidget extends StatefulWidget {
  @override
  _RestorativeValWidgetState createState() => _RestorativeValWidgetState();
}

//TODO: editable text...
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
