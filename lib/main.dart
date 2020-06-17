import 'package:flutter/material.dart';

// TODO: modularize, split into different .dart files
// TODO: hero animations in a grid view
// TODO: start with basic functionality

void main() {
  runApp(MyApp());
}

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

  Activity (this.img, this.title, this.description, this.lifepoints)
  {
    _activityID = new UniqueKey();
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Performing Yoga for fun',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'a restorative activity',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
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
          //_buildButtonColumn(color, Icons.edit, 'EDIT'), // just let them edit...
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Yoga! Doing yoga restores life energy, most of the time. Take care to not overdo it. '
        'This represents doing yoga, not teaching it. Teaching is hard! '
        'Think about if you want gentle or difficult yoga. Default is Youtube.',
        softWrap: true,
      ),
    );

    Widget activity = Column(
      children: <Widget>[
        Expanded(
          child: Image.asset('assets/images/teach.jpg'),
        ),
      ],
    );

    Widget viewSection = CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              // TODO: load these, probably lazy load...
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                    'assets/images/yoga.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/work.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/write.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/tarot.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/walk.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/teach.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/sims.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/learn.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/eat.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/chores.jpg',
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/workout.jpg',
                  ),
                ),
                //
                //)
              ]),
        ),
      ],
    );


    return MaterialApp(
      title: 'nah',
      home: Scaffold(
        appBar: AppBar(
          title: Text('nah. do less'),
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
