import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/singletons.dart';

// heavily borrows from the timeline_tile provided sample

class TimelineInsert extends StatefulWidget {
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFCCCA9),
            Color(0xFFFFA578),
          ],
        ),
      ),
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
                        for (int i = 0; i < thisDay.activities.length; i++)
                          Container(
                            key: UniqueKey(),
                            child: Dismissible(
                              // Each Dismissible must contain a Key. Keys allow Flutter to
                              // uniquely identify widgets.
                              // this isn't unique though... UniqueKey()
                              key: UniqueKey(),
                              // Provide a function that tells the app
                              // what to do after an item has been swiped away.
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  thisDay.activities.removeAt(i);
                                  // show snakcbar
                                });
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
                                    // TODO: make this exectute dismiss instead of just delete...
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
    );
  }
}

class _TimelineStepIndicator extends StatelessWidget {
  const _TimelineStepIndicator({Key key, this.step})
      : super(key: key);

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
      // here we explicitly set the size of our tiles
      height: 200,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: <Widget>[
          // to round the borders
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
                // want image to fill the box so use infinity..
                height: double.infinity,
                width: double.infinity,
                image: AssetImage(activity.imgPath),
                fit: BoxFit.cover),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(activity.title + " " + activity.lifepoints.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                )),
          ),
        ],
      ),
      ),
    );

/*
    return Padding(
      padding: isLeftAlign
          ? const EdgeInsets.only(right: 32, top: 16, bottom: 16, left: 10)
          : const EdgeInsets.only(left: 32, top: 16, bottom: 16, right: 10),
      child: Column(
        crossAxisAlignment:
            isLeftAlign ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            textAlign: isLeftAlign ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.acme(
              fontSize: 22,
              color: const Color(0xFFB96320),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: isLeftAlign ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.architectsDaughter(
              fontSize: 16,
              color: const Color(0xFFB96320),
            ),
          ),
        ],
      ),
    );*/
  }
}
/*
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Your day in order',
              textAlign: TextAlign.center,
              style: GoogleFonts.architectsDaughter(
                fontSize: 26,
                color: const Color(0xFFB96320),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
