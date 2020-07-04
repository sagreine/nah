import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:nah/app/today.dart';
import 'package:nah/app/activity.dart';

// heavily borrows from the timeline_tile provided sample

class TimelineInsert extends StatefulWidget {
  @override
  _TimelineInsertState createState() => _TimelineInsertState();
}

class _TimelineInsertState extends State<TimelineInsert> {
  DayOfActivities thisDay = DayOfActivities();

  Widget _pickChild(int index) {
    final int itemIndex = index ~/ 2;

    if (index.isOdd)
      return TimelineDivider(
        color: thisDay.activities[itemIndex].getLifePointsColor(),
        //steps[itemIndex].lifepoints <= 0 ? Colors.greenAccent : Colors.redAccent,
        //(0xFFCB8421),
        thickness: 5,
        begin: 0.1,
        end: 0.9,
      );

    final Activity step = thisDay.activities[itemIndex];

    final bool isLeftAlign = itemIndex.isEven;

    final child = _TimelineStepsChild(
      title: step.title,
      subtitle: step.description,
      isLeftAlign: isLeftAlign,
    );

    final isFirst = itemIndex == 0;
    final isLast = itemIndex == thisDay.activities.length - 1;
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
      rightChild: isLeftAlign ? child : null,
      leftChild: isLeftAlign ? null : child,
      lineX: isLeftAlign ? 0.1 : 0.9,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicatorY: indicatorY,
        indicator: _TimelineStepIndicator(
          step: step,
          index: itemIndex.toString(),
        ),
      ),
      topLineStyle: LineStyle(
        color: thisDay.activities[itemIndex].getLifePointsColor(),
        //step.lifepoints <= 0 ? Colors.greenAccent : Colors.redAccent,
        //Color(0xFFCB8421),
        width: 5,
      ),
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
                  _Header(),
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
                          Stack(
                            key: UniqueKey(),
                            children: <Widget>[
                             _pickChild(i),
                         InkWell(
                          child: Icon(
                            Icons.delete_sweep,
                            color: Colors.red,
                            size: 35,
                          ),
                          // TODO: make this exectute dismiss instead of just delete...
                          onTap: () {
                            setState(() {
                              thisDay.activities.removeAt(i);
                              // Then show a snackbar.
                              // needs scaffold (use builder or global key)
                              /*
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      activity.title + " removed from today")));
                                      */
                            });
                          },
                        ),
                            ],
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
  const _TimelineStepIndicator({Key key, this.step, this.index})
      : super(key: key);

  final Activity step;
  final String index;

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
          //index,
          step.title,
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
  const _TimelineStepsChild({
    Key key,
    this.title,
    this.subtitle,
    this.isLeftAlign,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool isLeftAlign;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

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
