import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nah/app/activity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/home.dart';
import 'package:nah/app/singletons.dart';
import 'package:image_picker/image_picker.dart';

/// TODO: SliverAnimatedList instead? much more fun. also explicit animations instead of roll your own.. :)
/// also also, naturally lends to the coming reorganziation/state-conscious editing of the code
/// Existing activities: do we want editable by default, or click edit button to edit?
/// new activities default to editable. then after pressed, are they or not?
/// TODO: add submit button on description editing instead of hack

// if we want to know if adding or editing, make that a parameter of the screen
// e.g. to know if we want to make them press Edit. or, if they can have a delete button.

class DetailScreen extends StatefulWidget {
  final Activity activity;
  final FABController controller;
  final Function callbackDetail;

  // this.activity was required, but let's not require it for a new on. or pass blank one?
  const DetailScreen(
      {Key key, @required this.activity, this.controller, this.callbackDetail})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(controller);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(FABController _controller) {
    if (_controller != null) {
      _controller.onFab = onFab;
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lifePointsController = TextEditingController();
  AllActivities _allActivities = AllActivities();

// this parameter is unnecessary and stupid of course. just build a camera with gallery overlay...
// https://medium.com/@richard.ng/whatsapp-clone-with-flutter-in-a-week-part-2-d5e394e76b22
  Future getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      // if they picked a file :)
      if (pickedFile != null) {
        // inefficient but does it. check if any other Activity has this exact imagePath and fail if so.
        widget.activity.imgPath = pickedFile.path.toString();
      }
    });
  }

  // what happens when they submit this image?
  // this should save it, but mind that this is a state and we're doing widget.activity.....
  // note that this is only what happens on this page, other things can happen on other pages, see controller definition
  // specifically, no need to set state on this page since it does nothing to the Detail page.
  bool onFab() {
    /// this fab function is for the Home FAB, for adding, not the Detail FAB for editing. this is very stupid of course
    if (widget.activity != null) {
      // check if another activity already has this image (breaks Hero animation). if so, return false
      for (int i = 0; i < _allActivities.activities.length; ++i) {
        if (_allActivities.activities[i].imgPath == widget.activity.imgPath) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Another activity has this image. Try again"),
          ));
          return false;
        }
      }
      // otherwise add this activity and return true
      _allActivities.activities.add(widget.activity);
      return true;
    }
    return false;
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
    _titleController.text = widget.activity.title;
    _descriptionController.text = widget.activity.description;
    // do we want this different for new vs edit? cuz it'll never be null for the TextFormField, if we care..
    _lifePointsController.text = widget.activity.lifepoints.toString();

    SnackBar snack = SnackBar(
      content: Text(widget.activity.title + " edits saved"),
      elevation: 8,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      /*action: SnackBarAction(
          // TODO: undo add to day
          label: 'Undo',
          onPressed: () {},
        ),*/
    );

    Widget imageSection = Hero(
      tag: AssetImage(widget.activity.imgPath),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // doubletap may be inappropriate material.io here, user expecting Tap instead...
          onDoubleTap: () {
            // double tap sets the state of list then pops -> real bad on Add though so don't do that.
            if (widget.callbackDetail != null) {
              widget.callbackDetail(snack);
              Navigator.of(context).pop();
            }
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
                    color: widget.activity.getLifePointsColor(),
                  ),
                ),
                // fadeinimage but seems broken.
                child: Image.asset(widget.activity.imgPath),
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
          //_lifePointsWidget(),
          Container(
            padding: EdgeInsets.all(0),
            // this isn't an inconbutton anymore though...
            child: IconButton(
                icon: (widget.activity.lifepoints < 0
                    ? Icon(FontAwesomeIcons.levelUpAlt)
                    : Icon(
                        FontAwesomeIcons.levelDownAlt,
                      )),
                color: (widget.activity.getLifePointsColor()),
                onPressed: () {
                  setState(() {
                    widget.activity.lifepoints = -widget.activity.lifepoints;
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
                    widget.activity.lifepoints = int.parse(value);
                    print(widget.activity.lifepoints.toString());
                  },
                );
                // update bool for is positive? or have that pull from activity and update automatically.
              },
            ),
          ),
        ],
      ),
    );

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

          _buildButtonColumn(
              _allActivities.activities.contains(widget.activity)
                  ? Colors.red
                  : Colors.transparent,
              Icons.delete_forever,
              'DELETE FOREVER')
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
        /*keyboardType: TextInputType.multiline,
        minLines: 1,*/
        maxLines: null,
        // TODO: don't do this. add a submit button.
        onSubmitted: (value) {
          widget.activity.description = value;
        },
      ),
    );

    Widget viewSection = ListView(
      children: [
        imageSection,
        buttonSection,
        titleSection,
        textSection,
      ],
    );

    return viewSection;
  }

  // builds bottom buttons on edit page..
  // do we want differences based on Add vs Edit? e.g. no/transparent delete button..
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    SnackBar snack = SnackBar(
      content: Text("Deleted " + widget.activity.title + " activity"),
      elevation: 8,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      /*action: SnackBarAction(
          // TODO: undo add to day
          label: 'Undo',
          onPressed: () {},
        ),*/
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //iconButton
        InkWell(
          child: Icon(icon, color: color, size: 36),
          // it would exit the tab. so we could return to listScreen (should you be able to permanently delete activity from Today?)
          onTap: () {
            // well obviously bad form here....
            _allActivities.activities.contains(widget.activity)
                ? {
                    _allActivities.activities.remove(widget.activity),
                    widget.callbackDetail(snack),
                    Navigator.of(context).pop(),
                  }
                : null;
          },
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
