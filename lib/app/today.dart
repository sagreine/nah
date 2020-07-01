import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';

///// needs to be a list, not a set, as activities can repeat here
/// TODO: retain reordering across life of screen (if i go back, then return, i want to save my order) --- this happens now, just not setState()...
/// TODO: obviously, this is no longer a stateless widget....
/// TODO: custom timeline rather than reorderable list? more fun :)
/// TODO: animated list? much more fun especially for deletion sweep :)
///
///
///

// Singleton for the day. trying it out. not sure why it is in this file though.
class DayOfActivities {
  //extends ExampleStateBase {
  static final DayOfActivities _instance = DayOfActivities._internal();

  List<Activity> activities;
  //int currentScore;

  factory DayOfActivities() {
    return _instance;
  }

  int getLifePointsSum() {
    int tmp = 0;
    activities.forEach((element) {
      tmp += element.lifepoints;
    });
    return tmp;
  }

  DayOfActivities._internal() {
    activities = List<Activity>();
  }
}

class TodayScreen extends StatefulWidget {
  @override
  TodayScreenState createState() => TodayScreenState();
}

class TodayScreenState extends State<TodayScreen> {
  DayOfActivities thisDay = DayOfActivities();

  @override
  Widget build(BuildContext context) {
    Widget _buildViewSection() {
      return ReorderableListView(
          //shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          onReorder: (_oldIndex, _newIndex) {
            setState(() {
              if (_newIndex > _oldIndex) {
                _newIndex -= 1;
              }
              thisDay.activities
                  .insert(_newIndex, thisDay.activities.removeAt(_oldIndex));
            });
          },
          header: Text("Drag to reorder"),
          children: <Widget>[
            for (final activity in thisDay.activities)

              // populated card, detail screen on long press
              Card(
                key: ValueKey(activity),
                shadowColor: Theme.of(context).primaryColorDark,
                child: InkWell(
                  splashColor: Theme.of(context).primaryColor.withAlpha(30),
                  onDoubleTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return Scaffold(
                          body: Container(
                              // if we want it small with the same background, do that here
                              // but be consistent across ways to get this screen
                              // just here for now as an example / another way to look at it.
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(16.0),
                              child: DetailScreen(activity: activity)),
                        );
                      }),
                    );
                  },
                  child: Dismissible(
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify widgets.
                    key: Key(activity.activityID.toString()),
                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        thisDay.activities.remove(activity);
                      });

                      // Then show a snackbar.
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text(activity.title + " removed from today")));
                    },
                    // Show a red background as the item is swiped away.
                    background: Container(color: Colors.red),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          //child: ListTile(title: Text('$item')),

                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              // so they don't get huge when dragging..
                              mainAxisSize: MainAxisSize.min,

                              // do we want these cards to be the same size? height?
                              // same as other page, same as each other, something else?

                              children: [
                                Image(height: 100, image: activity.img.image),
                                Text(activity.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.9),
                                    )),
                              ]),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.delete_sweep,
                            color: Colors.red,
                            size: 35,
                          ),
                          // TODO: make this exectute dismiss instead of just delete...
                          onTap: () {
                            setState(() {
                              thisDay.activities.remove(activity);                              
                              // Then show a snackbar.
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      activity.title + " removed from today")));
                            });
                            print(thisDay.activities.length);
                          },
                        ),

                        //selectedActivities.removeAt(index),
                      ],
                    ),
                  ),
                ),
              ),
          ]);
      //separatorBuilder: (BuildContext context, int index) => const Divider(),
    }

// change this to horizontal only, too easy to mix it up with moving thing.
    Widget viewSection = GestureDetector(
      onPanUpdate: (details) {
        // swipe left to look at today
        if (details.delta.dx > 0) {
          Navigator.of(context).pop();
          /*Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => TodayScreen(selectedActivities: _selectedActivities)),*/
        }
      },
      // the Activities for today...
      child: _buildViewSection(),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Today's Activitiies"),
        ),
        body: viewSection,
      ),
    );
  }
}
