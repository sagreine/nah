import 'package:flutter/material.dart';

// TODO: modularize, split into different .dart files
// TODO: hero animations in a grid view
// TODO: start with basic functionality

void main() {
  runApp(MyApp());
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
          /*3*/
          /*Icon(
            Icons.star,
            color: Colors.green[500],
          ),
          Text('+2'),*/
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
          //_buildButtonColumn(color, Icons.edit, 'EDIT'),
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

    return MaterialApp(
      title: 'nah',
      home: Scaffold(
        appBar: AppBar(
          title: Text('nah. do less'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'assets/images/yoga.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }

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
              (_isRestorative ? "+" : "-") + _restorePoints.toString()
            )
          )
        )
      ],
    );
  }
  void _toggleRestorative() {
    setState(() {
      _isRestorative = !_isRestorative;
    });
  }

}
