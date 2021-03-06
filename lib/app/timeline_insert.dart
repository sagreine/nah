import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/singletons.dart';

// heavily borrows from the timeline_tile provided sample

class TimelineInsert extends StatefulWidget {
  final Function callback;
  TimelineInsert({this.callback});

  @override
  _TimelineInsertState createState() => _TimelineInsertState();
}

class _TimelineInsertState extends State<TimelineInsert> {
  DayOfActivities thisDay = DayOfActivities();

  // stateless widget...refactor out of this class
  Widget _pickChild(int index) {
    final Activity step = thisDay.activities[index];

    final child = Container(
        child: _TimelineStepsChild(
      activity: step,
    ));

    final isFirst = index == 0;
    final isLast = index == thisDay.activities.length - 1;
    double indicatorY;
    if (isFirst) {
      indicatorY = 0.2;
    } else if (isLast) {
      indicatorY = 0.8;
    } else {
      indicatorY = 0.5;
    }

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineX: 0.1,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicatorY: indicatorY,
        // don't need to pass step if we do away with the color circle...
        indicator: _TimelineStepIndicator(
          step: step,
        ),
      ),
      topLineStyle: LineStyle(
        color: thisDay.activities[index].getLifePointsColor(),
        width: 5,
      ),
      rightChild: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Container(
            /*decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFCCCA9),
            Color(0xFFFFA578),
          ],
        ),
      ),*/
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: const Color(0xFFFCB69F).withOpacity(0.2),
              ),
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        //_Header(),
                        Expanded(
                          child: ReorderableListView(
                            onReorder: (_oldIndex, _newIndex) {
                              setState(() {
                                if (_newIndex > _oldIndex) {
                                  _newIndex -= 1;
                                }
                                thisDay.activities.insert(_newIndex,
                                    thisDay.activities.removeAt(_oldIndex));
                              });
                            },
                            children: <Widget>[
                              for (int i = 0;
                                  i < thisDay.activities.length;
                                  i++)
                                Container(
                                  key: UniqueKey(),
                                  child: Dismissible(
                                    direction: DismissDirection.endToStart,
                                    // Each Dismissible must contain a Key. Keys allow Flutter to
                                    // uniquely identify widgets.
                                    // this isn't unique though... UniqueKey()
                                    key: UniqueKey(),
                                    // Provide a function that tells the app
                                    // what to do after an item has been swiped away.
                                    onDismissed: (direction) {
                                      // Remove the item from the data source.

                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        setState(() {
                                          thisDay.activities.removeAt(i);
                                          // show snakcbar
                                        });
                                        // this would be after it already dismisses, so stop that!
                                        // https://gist.github.com/Nash0x7E2/08acca529096d93f3df0f60f9c034056
                                      }
                                      //else {
                                      //widget.callback();
                                      //}
                                    },
                                    // Show a red background as the item is swiped away.
                                    background: Container(color: Colors.red),

                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: _pickChild(i),
                                        ),
                                        InkWell(
                                          child: Icon(
                                            Icons.delete_sweep,
                                            color: Colors.red,
                                            size: 35,
                                          ),                                      
                                          //onTap: () {
                                          //setState(() {
                                          //thisDay.activities.removeAt(i);
                                          // snackbar show..
                                          //});
                                          //},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStepIndicator extends StatelessWidget {
  const _TimelineStepIndicator({Key key, this.step}) : super(key: key);

  final Activity step;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: step.getLifePointsColor(),
        //step.lifepoints <= 0 ? Colors.greenAccent : Colors.redAccent,
        // Color(0xFFCB8421),
      ),
      child: Center(
        child: Text(
          step.lifepoints.toString(),
          style: GoogleFonts.architectsDaughter(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _TimelineStepsChild extends StatelessWidget {
  const _TimelineStepsChild({Key key, this.activity}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 200,
        child: GridTile(
          child:
              // want image to fill the box so use infinity..
              ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
                height: double.infinity,
                width: double.infinity,
                image: AssetImage(activity.imgPath),
                fit: BoxFit.cover),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(activity.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(activity.lifepoints.toString(),
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
    );
  }
}
