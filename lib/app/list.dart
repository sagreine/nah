import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';
import 'package:nah/app/home.dart';
import "package:nah/app/state_container.dart";
import 'package:nah/app/singletons.dart';

//import 'home.dart';

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
  final FABController controller;


  ListScreen({this.controller});

  @override
  ListScreenState createState() => ListScreenState(controller);
}

class ListScreenState extends State<ListScreen> {
  // these are our global list of all activities and
  // list of activities we've selected
  // these should be maps. but also when look at state again,
  // because we should be able to delete them on the next page if we don't like them - maybe, anyway? could just make them come back here...
  // think: are these of state or statefulwidget
  //final List<Activity> _activities = List<Activity>();
  //List<Activity> _activitiesToAdd = List<Activity>();

  // may need to also override didUpdateWidget.
  ListScreenState(FABController _controller) {
    _controller.onFab = onFab;
  }
 
  // used to update this screen, typically because _allActivities has been updated and we've popped context back here
  // ^that might be unnecessary if i were a better programmer :)
  void callbackDetail(SnackBar snack) {
    setState(() {});
    
    Scaffold.of(context).showSnackBar(snack);

  }

  void onFab() {
    thisDay.activities.addAll(_selectedActivities);
    setState(() {
      _selectedActivities.clear();
    });
  }

  final List<Activity> _selectedActivities = List<Activity>();
  DayOfActivities thisDay = DayOfActivities();
  AllActivities _allActivities = AllActivities();

  AppSettings appSettings;

  
  @override
  void initState() {
    // TODO: implement initState correctly e.g. database pull
    super.initState();

    // think about this If -> if we start on Add New they'll only have their own. preference?
    if (_allActivities.activities.length == 0) {
      _allActivities.activities.add(Activity(
          'assets/images/yoga.jpg',
          "Yoga",
          "a Yoga subtitle",
          "This is doing yoga, not teaching it. Yoga is a great way to relax. Try doing it in the park! Or with a goat! Or a beer.",
          -2));
      _allActivities.activities.add(Activity(
          'assets/images/work.jpg',
          "Work",
          "a work subtitle",
          "Work. Can't live with it, can't live without it! Luckily they pay you, which is pretty cool I guess. It takes a lot though!",
          3));
      _allActivities.activities.add(Activity(
          'assets/images/write.jpg',
          "Write",
          "a write subtitle",
          "Writing is fun. Try doing it with crayons to be silly. edit: DON'T eat the crayons.",
          -2));
      _allActivities.activities.add(Activity(
          'assets/images/tv.jpg',
          "TV",
          "a tv subtitle",
          "Of course by 'TV' I mean 'Netflix'. It isn't 1996.",
          0));
      _allActivities.activities.add(Activity(
          'assets/images/eat.jpg',
          "Eat",
          "an eating subtitle",
          "Eating is amazing. I do it almost every day. I recommend 1 large pizza every 12-18 hours for best results.",
          0));
      _allActivities.activities.add(Activity(
          'assets/images/teach.jpg',
          "Teach",
          "a teaching subtitle",
          "This can be teaching anything. Yoga, programming, even eating. Mmm, eating.",
          1));
      _allActivities.activities.add(Activity(
          'assets/images/chores.jpg',
          "Chores",
          "a chores subtitle",
          "Everyone hates chores but everyone has to do them. Unless you're rich. In which case, please buy me a coffee.",
          2));
                _allActivities.activities.add(Activity(
          'assets/images/create.jpg',
          "Create",
          "a create subtitle",
          "Creating can be creating anything. Painting, drawing, making a low-quality time management app...anything!",          
          -1));
      _allActivities.activities.add(Activity(
          'assets/images/learn.jpg',
          "Learn",
          "a learn subtitle",
          "Learning is hard, but rewarding. You migth even learn how to make an app!",
          1));   
      _allActivities.activities.add(Activity(
          'assets/images/tarot.jpg',
          "Tarot",
          "a tarot subtitle",
          "Pretty pictures, fun mystery. Reading or making your own! Hope you can draw better than I can program.",
          -1));   
      _allActivities.activities.add(Activity(
          'assets/images/social.jpg',
          "Social",
          "a social subtitle",
          "Are you an introvert or an extrovert? Either way, you should probably socialize some. Yes, even you, introverts.",
          1));                        
      _allActivities.activities.add(Activity(
          'assets/images/workout.jpg',
          "Workout",
          "a workout subtitle",
          "Do you bench press 300 pounds? Me neither. But I can bench press more than I used to, and stronger people are harder to kill.",
          1));          
      _allActivities.activities.add(Activity(
          'assets/images/selfcare.jpg',
          "Self-Care",
          "a self-care subtitle",
          "Your happy place. Maybe it's the beach, maybe it's programming a free time management app. Either way, indulge in some bliss now and again, my friend.",
          -2));          
      _allActivities.activities.add(Activity(
          'assets/images/walk.jpg',
          "Walk",
          "a walk subtitle",
          "You have two legs. Or, maybe you don't, hell I don't know you. Either way, think about walking as a way to relax. Or at least a way to talk to food. Both, if you're lucky",
          -1));          
      _allActivities.activities.add(Activity(
          'assets/images/videogames.jpg',
          "Video Games",
          "a video games subtitle",
          "Are you killing zombies? Building simulated houses and people? Either way I recommend ordering and eating a pizza while you do it.",
          0));          
    }
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

    // push a new activity to detail screen and update the list of activities if you get one back
    // managed through e.g. PageView in future? (e.g., bottom nav bar navigation to Detail on Today needs very similar code to update _activities)
    // though with consideration of how exactly would you do that given you can go Today->new Detail. for now assume PageView has magic.
    // or _activities is singleton...

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
                // tag needs to be unique
                // this is a "watch out" for pages where you can have more than 1 of the same Activity
                // and a "watch out" here for more than one Activities having the same image (imgPath)
                // also an obvious "here's why" for separating e.g. MVC, we want to reuse this in a different screen but w/o  / w/ different actions
                tag: AssetImage(_allActivities.activities[index].imgPath),
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
                        if (_selectedActivities
                            .contains(_allActivities.activities[index])) {
                          _selectedActivities
                              .remove(_allActivities.activities[index]);
                          _currentScore -=
                              _allActivities.activities[index].lifepoints;
                          print("removed!");
                          print(toString());
                          print(_currentScore.toString());
                        } else {
                          // select if not going over the limit
                          if (_currentScore +
                                  _allActivities.activities[index].lifepoints <=
                              appSettings.lifePointsCeilling) {
                            _selectedActivities
                                .add(_allActivities.activities[index]);
                            _currentScore +=
                                _allActivities.activities[index].lifepoints;
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
                                      (_allActivities.activities[index]
                                                  .lifepoints +
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
                      });
                    },
                    onDoubleTap: () {
                      Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                              timeDilation = 2.5;
                              // why is a scaffold necessary?
                              // TODO: this doesn't set state, even when this is wrapped in setState. only after it is rebuilt again..
                              return Scaffold(
                                body: Container(
                                  // if we want it small with the same background, do that here
                                  // but be consistent across ways to get this screen
                                  // just here for now as an example / another way to look at it.
                                  alignment: Alignment.center,

                                  // this feels like transparent should show what's behind it, but it doesn't..
                                  //color: Color(0xffE49273),
                                  //color: Colors.transparent,

                                  padding: const EdgeInsets.all(16.0),
                                  child: DetailScreen(
                                    activity: _allActivities.activities[index], callbackDetail: callbackDetail),                                
                                    // this is NOT a thing we should do and it doesn't worki :)
                                    //controller: new FABController()
                                  ),                              
                              );
                            }),                          
                          );
                    },
                    child: GridTile(
                      child:
                          // want image to fill the box so use infinity..
                          ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                            height: double.infinity,
                            width: double.infinity,
                            image: AssetImage(
                                _allActivities.activities[index].imgPath),
                            fit: BoxFit.cover),
                      ),
                      header: Icon(
                        Icons.check_circle,
                        size: 100.0,
                        color: _selectedActivities
                                .contains(_allActivities.activities[index])
                            ? Color(0xffA8D0DB)
                            : Colors.transparent,
                      ),
                      footer: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              //width: double.infinity,
                              height: 45,
                              padding: EdgeInsets.all(5),
                              color: Colors.blueGrey.withOpacity(
                                  .8), //Theme.of(context).primaryColor.withOpacity(.8),

                              //alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(_allActivities.activities[index].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                      _allActivities
                                          .activities[index].lifepoints
                                          .toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: _allActivities.activities.length,
        ),
      );
    }

    // just swipting = no additions happened (stop handling this here :))
    Widget viewSection = CustomScrollView(
      primary: false,
      slivers: <Widget>[
        _buildViewSection(),
      ],
    );
    return viewSection;
  }
}
