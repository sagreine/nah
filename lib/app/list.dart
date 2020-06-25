import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';
import 'package:nah/app/today.dart';

// push to a builder of slivers for selected day....
// not a map though? or pushes to a map but reads
// into a list so you can have multiple of one...
// TODO: lifepoints check. on tap?

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  // these are our global list of all activities and
  // list of activities we've selected
  // these should be maps. but also when look at state again,
  // because we should be able to delete them on the next page if we don't like them.
  final List<Activity> _activities = List<Activity>();
  final List<Activity> _selectedActivities = List<Activity>();

  @override
  Widget build(BuildContext context) {
    // this part obviously doesn't go here, done every build, just testing
    // will come from db anyhow...
    _activities.add(Activity(Image.asset('assets/images/yoga.jpg'), "Yoga!", "a Yoga subtitle",
        "this is yoga description", 2));
    _activities.add(Activity(Image.asset('assets/images/work.jpg'), "work...!", "a work subtitle",
        "this is a description for work", -1));
    _activities.add(Activity(Image.asset('assets/images/write.jpg'),
        "write...!", "a write subtitle", "this is a description for write", -6));
    _activities.add(Activity(Image.asset('assets/images/tv.jpg'), "tv...!", "a tv subtitle",
        "this is a description for tv", 0));
    _activities.add(Activity(Image.asset('assets/images/eat.jpg'), "eat...!", "an eating subtitle",
        "this is a description for eat", 7));
    _activities.add(Activity(Image.asset('assets/images/teach.jpg'),
        "teach...!", "a teaching subtitle", "this is a description for teach", -1));
    _activities.add(Activity(Image.asset('assets/images/chores.jpg'),
        "chores...!", "a chores subtitle", "this is a description for chores", -2));

    Widget _buildViewSection() {
      // may eventually return to just one column....
      // this is a grid of slivers that will hold our activities
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 10.0,
          // change sizing of images here
          childAspectRatio: 2.0,
        ),
        // this builds each individual activity

        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            // this seems like a real bad way to do this.

            // load from db up front or lazy here directly?
            // performance considerations.
            // use ListTile instead of card....
            return Card(
              // weight this color by lifepoint
              //color: _activities[index].getLifePointsColor(),
              shadowColor: Theme.of(context).primaryColorDark,

              // this enables cool animations when getting details
              child: Hero(
                tag: _activities[index].img,
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
                      setState(() {
                        if (_selectedActivities.contains(_activities[index])) {
                          _selectedActivities.remove(_activities[index]);
                          print("removed!");
                        } else {
                          _selectedActivities.add(_activities[index]);
                          print("added!");
                        }
                        // update border, may have to put onTap on the container....
                        // alreadyAdded ? Colors.red : null;
                      });
                    },
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          timeDilation = 2.5;
                          return Scaffold(
                            body: Container(
                                child:
                                    DetailScreen(activity: _activities[index])),
                          );
                        }),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedActivities.contains(_activities[index])
                            ? Color(0xff2B4570)
                            : Color(0xffA8D0DB),
                        // color: _selectedActivities.contains(_activities[index]) ?  Theme.of(context).primaryColorDark :  Theme.of(context).primaryColorLight,
                        /*border: Border.all(
                            color: _activities[index].getLifePointsColor(),
                          )*/
                      ),
                      child: Stack(
                        children: <Widget>[
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _activities[index].img,
                                ),
                                Text(_activities[index].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.9),
                                    )),
                              ]),
                          Icon(
                            Icons.check_circle,
                            size: 35.0,
                            color:
                                _selectedActivities.contains(_activities[index])
                                    ? Color(0xffA8D0DB)
                                    : Colors.transparent,
                          )
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

    // or just handle through bottom abb par? or no button at all which is ideal anyway...
    Widget viewSection = GestureDetector(
      onPanUpdate: (details) {
        // swipe left to look at today
        if (details.delta.dx < 0) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => TodayScreen(selectedActivities: _selectedActivities)),
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
                  child: DetailScreen(activity:
                     Activity(
                     Image.asset('assets/images/default.jpg'), 
                     "Add a title to this activity", 
                     "Add a subtitle to this activity",
                     "Add an activity description!", 
                     7,
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
              expandedHeight: 75.0,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Activities'),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add new',
                  onPressed: () {/* TOOD: add a new item to activities */},
                ),
              ]),
          _buildViewSection(),
        ],
      ),
    );

    return MaterialApp(
      title: 'nah',
      home: Scaffold(
        backgroundColor: Color(0xffE49273),
        //Color(0xFF7180AC),
        //Theme.of(context).primaryColorLight.withOpacity(0.9),
        body: viewSection,
      ),
    );
  }
}
