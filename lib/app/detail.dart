import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/today.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// TODO: SliverAnimatedList instead? much more fun. also explicit animations instead of roll your own.. :)
/// also also, naturally lends to the coming reorganziation/state-conscious editing of the code
/// Existing activities: do we want editable by default, or click edit button to edit?
/// new activities default to editable. then after pressed, are they or not?
/// TODO: fix animation and etc on textfield editing.
/// TODO: add submit button on description editing instead of hack

// if we want to know if adding or editing, make that a parameter of the screen
// e.g. to know if we want to make them press Edit. or, if they can have a delete button. 

class DetailScreen extends StatefulWidget {
  final Activity activity;
  // this.activity was required, but let's not require it for a new on. or pass blank one?
  const DetailScreen({Key key, @required this.activity}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentIndex = 0;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

// this parameter is unnecessary and stupid of course. just build a camera with gallery overlay...
// https://medium.com/@richard.ng/whatsapp-clone-with-flutter-in-a-week-part-2-d5e394e76b22
  Future getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      // if they picked a file :)
      if (pickedFile != null) {
        widget.activity.imgPath = pickedFile.path.toString();
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.activity.title;
    _descriptionController.text = widget.activity.description;

    Widget imageSection = Hero(
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
              // maybe a gif in the future :)
              new FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage(widget.activity.imgPath),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    child:
                        Icon(Icons.camera_alt, color: Colors.white, size: 48),
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ],
          ),
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
              child: TextField(
                controller: _titleController,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                // doesn't do what i thought it did :(
                expands: false,
                onSubmitted: (value) {
                  widget.activity.title = value;
                },
              ),
            ),
          ),
          RestorativeValWidget(),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // what buttons do we even want? delete for sure, but do we need any others?
          // what alignment do we want? size? etc.
          // do we want this to show on "Add Activity" or just "Edit"?
          // do we have that info?
          //_buildButtonColumn(color, Icons.add_circle_outline, 'ADD'),
          //_buildButtonColumn(color, Icons.edit_attributes, 'Edit'),
          _buildButtonColumn(color, Icons.delete_forever, 'DELETE'),
        ],
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      color: widget.activity.getLifePointsColor(),
      child: TextField(
        controller: _descriptionController,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        // TODO: don't do this. add a submit button.
        onChanged: (value) {
          widget.activity.description = value;
        },
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
          imageSection,
          buttonSection,
          titleSection,
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
  // do we want differences based on Add vs Edit? e.g. no/transparent delete button..
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Icon(icon, color: color),
          // TODO: delete this activity somehow? or we can just not have this icon on the page at all of course
          onTap: () {},
        ),
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
