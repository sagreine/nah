import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/today.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// TODO: SliverAnimatedList instead? much more fun. also explicit animations instead of roll your own.. :)
/// also also, naturally lends to the coming reorganziation/state-conscious editing of the code

class DetailScreen extends StatefulWidget {
  final Activity activity;
  // this.activity was required, but let's not require it for a new on. or pass blank one?
  const DetailScreen({Key key, @required this.activity}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentIndex = 0;

// this is unnecessary and stupid of course. just build a camera with gallery overlay...
// https://medium.com/@richard.ng/whatsapp-clone-with-flutter-in-a-week-part-2-d5e394e76b22
  Future getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      widget.activity.imgPath = pickedFile.path.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget fromhero = Hero(
      tag: AssetImage(widget.activity.imgPath),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // doubletap may be inappropriate material.io here, user expecting Tap instead...
          onDoubleTap: () {
            // will want to pass the activity back?
            // or, only if the activity was edited? comparison?
            // need to do hero everywhere to ensure pop back to right place?
            // Navigator.pop(context, activity);
            Navigator.of(context).pop();
          },
          child: Stack(
            children: <Widget>[
              // fadeInImage but doesn't work directly.... why?
              Center(child: CircularProgressIndicator()),
              // repercussions of new vs FadeInImage.asset etc.?
              new FadeInImage(
                placeholder: MemoryImage(
                    kTransparentImage), //AssetImage("assets/images/default.jpg"),
                image: AssetImage(widget.activity.imgPath),
                //Image(
//                image: AssetImage(widget.activity.imgPath),
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    child:
                        Icon(Icons.camera_alt, color: Colors.white, size: 32),
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
              //FadeInImage.memoryNetwork(
              //placeholder: kTransparentImage,
              //image:  Image.asset(activity.img),
            ],
          ),
          // ),
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
                widget.activity.title,
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
      color: widget.activity.getLifePointsColor(),
      child: Text(
        widget.activity.description,
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
      title: widget.activity.title,
      home: Scaffold(
        appBar: AppBar(
          title: Text("View and Edit Detail for Activity"),
        ),
        body: viewSection,
        floatingActionButton: Container(
          height: 80,
          width: 90,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: 'Back previous',
            child: Icon(Icons.done),
            elevation: 12,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.blueGrey,
          notchMargin: 3.5,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                /*
                setState(() {
                  _currentIndex = index;                  
                  if (_currentIndex == 2) {
                    // N/A, we're here already...
                  } 
                  else if (_currentIndex == 1)
                  {
                    Navigator.of(context).pop();
                  }
                  else {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (context) => DetailScreen(
                        //default is a 0 score activity
                        activity: Activity(
                          Image.asset('assets/images/default.jpg'),
                          "Add a title to this activity",
                          "Add a subtitle to this activity",
                          "Add an activity description!",
                          0,
                        ),
                      ),
                    ));
                  }
                });
                */
                //_navigateToScreens(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.edit),
                    title: Text("Create Activity")),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.truckPickup),
                    title: Text("Pick Activities")),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_day),
                  title: Text("View Today"),
                  // pass _activitiesToAdd...?
                ),
              ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
