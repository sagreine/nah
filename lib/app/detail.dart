import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nah/app/activity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nah/app/settings.dart';
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
  // deal with a blank one here..
  DetailScreen({Key key, @required this.activity}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lifePointsController = TextEditingController();
  Activity _activity;

// this parameter is unnecessary and stupid of course. just build a camera with gallery overlay...
// https://medium.com/@richard.ng/whatsapp-clone-with-flutter-in-a-week-part-2-d5e394e76b22
  Future getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      // if they picked a file :)
      // widget.activity vs. _activity this should work but is sloppy for sure
      if (pickedFile != null) {
        _activity.imgPath = pickedFile.path.toString();
        print("lallala");
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _titleController.dispose();
    _descriptionController.dispose();
    _lifePointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if passed null activity, populate with a default one
    // this seems like a really bad idea.

    if (widget.activity == null) {
      _activity = new Activity(
          'assets/images/default.jpg',
          "Add a title to this activity",
          "Add a subtitle to this activity",
          "Add an activity description!",
          0);
    } else {
      _activity = widget.activity;
    }

    _titleController.text = _activity.title;
    _descriptionController.text = _activity.description;
    // do we want this different for new vs edit? cuz it'll never be null for the TextFormField, if we care..
    _lifePointsController.text = _activity.lifepoints.toString();

    Widget imageSection = Hero(
      tag: AssetImage(_activity.imgPath),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // doubletap may be inappropriate material.io here, user expecting Tap instead...
          onDoubleTap: () {
            // this might not work, pending PageView implementation
            Navigator.of(context).pop();
          },
          child: Stack(
            children: <Widget>[
              // fadeInImage but doesn't work directly.... why?
              Center(child: CircularProgressIndicator()),
              // repercussions of new vs FadeInImage.asset etc.?
              // maybe a gif in the future :)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _activity.lifepoints < 0
                          ? Colors.greenAccent
                          : Colors.redAccent),
                ),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: AssetImage(_activity.imgPath),
                ),
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

    Container _lifePointsWidget() {
      return Container(
        // margin seems incorrect here -> add in the row, not here?
        margin: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
      );
    }

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
                  _activity.title = value;
                },
              ),
            ),
          ),
          //_lifePointsWidget(),
          Container(
            padding: EdgeInsets.all(0),
            // this isn't an inconbutton anymore though...
            child: IconButton(
                icon: (_activity.lifepoints < 0
                    ? Icon(FontAwesomeIcons.levelUpAlt)
                    : Icon(
                        FontAwesomeIcons.levelDownAlt,
                      )),
                color: (_activity.lifepoints < 0
                    ? Colors.green[500]
                    : Colors.red[500]),
                onPressed: () {
                  setState(() {
                    _activity.lifepoints = -_activity.lifepoints;
                  });
                }),
          ),
          Expanded(
            child: TextField(
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.greenAccent,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                ),
                labelText: "LifePoints",
              ),
              // you should be able to not allow decimal to show but it doesn't work
              keyboardType: TextInputType.number,
              // built in static property for digits only, but we want negatives so rolllll it :(
              // a typical negative regex doesn't work either?
              inputFormatters: <TextInputFormatter>[
                // you can't whitelist your way to a negative number right now ????
                // i guess we'll just make it negative the other way for now.
                //WhitelistingTextInputFormatter(RegExp('r[^-?\d+]')),
                //RegExp(r'^-?\d+')
                //RegExp(r'^-?[0-9](\d+')
                //RegExp(r'^-?\d+(\d+)')
                //r'[\d+\-]'
                // so use this for now
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              controller: _lifePointsController,
              onSubmitted: (String value) {
                setState(
                  () {
                    _activity.lifepoints = int.parse(value);
                    print(_activity.lifepoints.toString());
                  },
                );
                // update bool for is positive? or have that pull from activity and update automatically.
              },
            ),
          ),
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
      color: _activity.getLifePointsColor(),
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
          _activity.description = value;
        },
      ),
    );

    Widget viewSection = ListView(
      children: [
        imageSection,
        titleSection,
        textSection,
        buttonSection,
      ],
    );

    return viewSection;

    /*
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop(widget.activity);
            },
            ),
            */
  }

  // builds bottom buttons on edit page..
  // do we want differences based on Add vs Edit? e.g. no/transparent delete button..
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Icon(icon, color: color, size: 36),
          // TODO: delete this activity somehow? or we can just not have this icon on the page at all of course
          // it would exit the tab. so we could return to listScreen (should you be able to permanently delete activity from Today?)
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
