import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';
import 'package:nah/app/today.dart';
import 'package:nah/app/settings.dart';
import "package:nah/app/state_container.dart";

///// Generally thinking go away from strict navigator and prefer
///   bottomNavBar and PageView, managed out of home, for simplicity...
/*if((currentIndex-index).abs()==1){
      pageController.animateToPage(
        index, duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
    }else{
      pageController.jumpToPage(index);
    }*/

// not a map though? or pushes to a map but reads
// into a list so you can have multiple of one...
// just using list for now to not deal with it basically, iterable by index speed vs. math Set guarantees - not needed, though could be assumed so faster if searching non-index

// TODO: Error by banner? or snackbar + brief red border highlight inkwell splash?
// TODO: Positioned.fill for stack for background?

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  // these are our global list of all activities and
  // list of activities we've selected
  // these should be maps. but also when look at state again,
  // because we should be able to delete them on the next page if we don't like them - maybe, anyway? could just make them come back here...
  final List<Activity> _activities = List<Activity>();
  //List<Activity> _activitiesToAdd = List<Activity>();
  final List<Activity> _selectedActivities = List<Activity>();
  DayOfActivities thisDay = DayOfActivities();

// this will change when we use PageView but for now used to tell which page we're on and pick the next one
  int _currentIndex = 0;

  AppSettings appSettings;

  // this is massively unnecessary, right?
  /// i couldn't immediately see why scaffold of context in the FAB didn't work, with snack behavior set to floating though.
  GlobalKey<ScaffoldState> scaffoldState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaffoldState = GlobalKey();

    // this part obviously doesn't go here, done every build, just testing
    // will come from db anyhow...
    _activities.add(Activity('assets/images/yoga.jpg', "Yoga!",
        "a Yoga subtitle", "this is yoga description", -2));
    _activities.add(Activity('assets/images/work.jpg', "work...!",
        "a work subtitle", "this is a description for work", 3));
    _activities.add(Activity(
        'assets/images/write.jpg',
        "write...!",
        "a write subtitle",
        "this is a description for write",
        -2));
    _activities.add(Activity('assets/images/tv.jpg', "tv...!",
        "a tv subtitle", "this is a description for tv", 0));
    _activities.add(Activity('assets/images/eat.jpg', "eat...!",
        "an eating subtitle", "this is a description for eat", 0));
    _activities.add(Activity(
        'assets/images/teach.jpg',
        "teach...!",
        "a teaching subtitle",
        "this is a description for teach",
        1));
    _activities.add(Activity(
        'assets/images/chores.jpg',
        "chores...!",
        "a chores subtitle",
        "this is a description for chores",
        2));
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    appSettings = container.appSettings;
    // 'need' a only-this-context running sum since we aren't adding
    // activities to the day right away.
    // however, don't keep this here. only here to force recalc every setState()
    int _currentScore = thisDay.getLifePointsSum();
    _selectedActivities.forEach((element) {
      _currentScore += element.lifepoints;
    });


    Widget _buildViewSection() {
      // may eventually return to just one column....
      // this is a grid of slivers that will hold our activities

      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          // change here to see more activities in a given row
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 5,
          crossAxisSpacing: 3,
        ),
        // this builds each individual activity

        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            // this seems like a real bad way to do this.

            // load from db up front or lazy here directly?
            // performance considerations.
            return Container(
              height: double.infinity,
              width: double.infinity,

              // this enables cool animations when getting details
              child: Hero(
                // does this work? also is it necessary to create an image just for this...?
                tag: AssetImage(_activities[index].imgPath),
/*                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  final Hero toHero = toHeroContext.widget;
                  return RotationTransition(
                    turns: animation,
                    child: toHero.child,
                  );
                },*/
                child: Material(
                  // transparent enhances hero animation
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColor.withAlpha(30),
                    onTap: () {
                      // TODO: This is a default setting to not stop them in their tracks
                      // could push them directly to settings page, snackbar them to, even a flyin widget to edit it.
                      // this is broken for first item they select no longer being selected, at least when settings is null to start.
                      if (appSettings == null) {
                        container.updateAppSettings(10);
                        appSettings = container.appSettings;
                      }
                      setState(() {
                        // unselect and remove
                        if (_selectedActivities.contains(_activities[index])) {
                          _selectedActivities.remove(_activities[index]);
                          _currentScore -= _activities[index].lifepoints;
                          print("removed!");
                          print(toString());
                          print(_currentScore.toString());
                        } else {
                          // select if not going over the limit
                          if (_currentScore + _activities[index].lifepoints <=
                              appSettings.lifePointsCeilling) {
                            _selectedActivities.add(_activities[index]);
                            _currentScore += _activities[index].lifepoints;
                            print("added!");
                            print(appSettings.lifePointsCeilling.toString());
                            print(_currentScore.toString());
                          } else {
                            // you can't cuz it is too expensive
                            print("Error, too many things");
                            print(appSettings.lifePointsCeilling.toString());
                            print(_currentScore.toString());
                            final snackBar = SnackBar(
                              // unsure -> banner may be more approriate here
                              content: Text(
                                  "Nah, you're doing too much! Do less :) This is " +
                                      (_activities[index].lifepoints +
                                              _currentScore -
                                              appSettings.lifePointsCeilling)
                                          .toString() +
                                      " too many lifepoints"),
                              elevation: 8,
                              behavior: SnackBarBehavior.floating,
                              //action: SnackBarAction(
                              //label: 'Edit LifePoints Quota',
                              //onPressed: () {
                              // Some code to undo the change.
                              //
                              //},
                              //),
                            );

                            // Find the Scaffold in the widget tree and use
                            // it to show a SnackBar.
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        }
                        // update border, may have to put onTap on the container....
                        // alreadyAdded ? Colors.red : null;
                      });
                    },
                    onDoubleTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          timeDilation = 2.5;
                          return Scaffold(
                            body: Container(
                                // if we want it small with the same background, do that here
                                // but be consistent across ways to get this screen
                                // just here for now as an example / another way to look at it.
                                alignment: Alignment.center,

                                // this feels like transparent should show what's behind it, but it doesn't..
                                color: Color(0xffE49273),
                                //color: Colors.transparent,

                                padding: const EdgeInsets.all(16.0),
                                child:
                                    DetailScreen(activity: _activities[index])),
                          );
                        }),
                      );
                    },
                    // this is dumb. use a listTile... but image isn't great as it is too small
                    // straightforward adaptation breaks things though..
                    // only remaining 'issue' is checkbox is transparent, could just not use a transparent icon...
                    // well it's also very ugly. Switch to icons instead of images generally?
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedActivities.contains(_activities[index])
                            ? Color(0xff2B4570)
                            : Color(0xffA8D0DB),
                      ),
                      child: Stack(
                        children: <Widget>[
                          // want image to fill the box so use infinity..
                          Image(
                              height: double.infinity,
                              width: double.infinity,
                              image: AssetImage(_activities[index].imgPath),
                              fit: BoxFit.cover),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                                _activities[index].title +
                                    " " +
                                    _activities[index].lifepoints.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                )),
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 35.0,
                            color:
                                _selectedActivities.contains(_activities[index])
                                    ? Color(0xffA8D0DB)
                                    : Colors.transparent,
                          ),
                          //Text(_activities[index].lifepoints.toString(),
                          //textAlign: TextAlign.end,
                          //),
                        ],
                      ),
                      //border: Colors.red,
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: _activities.length,
        ),
      );
    }

    // just swipting = no additions happened (stop handling this here :))
    Widget viewSection = GestureDetector(
      onPanUpdate: (details) {
        // swipe left to look at today
        if (details.delta.dx < 0) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => TodayScreen()),
          );
        }
        // swipe right to add a new activity
        // should we async await then save? what if they change their mind...
        else {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (BuildContext context) {
              timeDilation = 2.5;
              return Scaffold(
                body: Container(
                  child: DetailScreen(
                    //default is a 0 score activity
                    activity: Activity(
                      'assets/images/default.jpg',
                      "Add a title to this activity",
                      "Add a subtitle to this activity",
                      "Add an activity description!",
                      0,
                    ),
                  ),
                ),
              );
            }),
          );
        }
      },
      // the Activities you can select from
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverAppBar(
              //expandedHeight: 75.0,
              floating: false,
              pinned: true,
              snap: false,
              leading: Image.asset("assets/images/ic_launcher.png"),
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Activities'),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add new Activity',
                  onPressed: () {/* TOOD: add a new item to activities */},
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => Settings()),
                    );
                  },
                ),
              ]),
          _buildViewSection(),
        ],
      ),
    );

    void _onPressedFAB() {
      // tell the user it worked then clear everyting.
      // don't need to create then dispose every time....
      SnackBar snack = SnackBar(
        content: Text("Added these to your day!"),
        elevation: 8,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          // TODO: undo add to day
          label: 'Undo',
          onPressed: () {},
        ),
      );

      // add this selection to Today then clear selected
      thisDay.activities.addAll(_selectedActivities);
      setState(() {
        _selectedActivities.clear();
      });

      scaffoldState.currentState.showSnackBar(snack);
    }

    return MaterialApp(
      title: 'nah',
      home: Scaffold(
        key: scaffoldState,
        backgroundColor: Color(0xffE49273),
        //Color(0xFF7180AC),
        //Theme.of(context).primaryColorLight.withOpacity(0.9),
        body: viewSection,
        // consider extended, with an icon and text, instead. e.g. "add to today"
        // still not sold on approach here. might prefer bottomNav with no add button...
        // in fact probably will do that!
        floatingActionButton: Container(
          height: 80,
          width: 90,
          child: FloatingActionButton(
            onPressed: _onPressedFAB,
            tooltip: 'Add to Day',
            child: Icon(Icons.add),
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
                setState(() {
                  _currentIndex = index;
                  // this will change when we add PageView
                  // but, nav to the other screens this way basically
                  if (_currentIndex == 1) {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => TodayScreen()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (context) => DetailScreen(
                        //default is a 0 score activity
                        activity: Activity(
                          'assets/images/default.jpg',
                          "Add a title to this activity",
                          "Add a subtitle to this activity",
                          "Add an activity description!",
                          0,
                        ),
                      ),
                    ));
                  }
                });
                //_navigateToScreens(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.edit),
                    title: Text("Create Activity")),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_day),
                  title: Text("View Today"),
                  // pass _activitiesToAdd...?
                ),
              ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
