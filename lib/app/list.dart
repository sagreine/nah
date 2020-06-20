import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // these are our global list of all activities and
  // list of activities we've selected
  List<Activity> _activities = List<Activity>();
  List<Activity> _selectedActivities = List<Activity>();

  @override
  Widget build(BuildContext context) {
    // this part obviously doesn't go here, done every build, just testing
    // will come from db anyhow...
    _activities.add(Activity(Image.asset('assets/images/yoga.jpg'), "Yoga!",
        "this is yoga description", 2));
    _activities.add(Activity(Image.asset('assets/images/work.jpg'), "work...!",
        "this is a description for work", -1));
    _activities.add(Activity(Image.asset('assets/images/write.jpg'),
        "write...!", "this is a description for write", -6));
    _activities.add(Activity(Image.asset('assets/images/tv.jpg'), "tv...!",
        "this is a description for tv", 0));
    _activities.add(Activity(Image.asset('assets/images/eat.jpg'), "eat...!",
        "this is a description for eat", 7));
    _activities.add(Activity(Image.asset('assets/images/teach.jpg'),
        "teach...!", "this is a description for teach", -1));
    _activities.add(Activity(Image.asset('assets/images/chores.jpg'),
        "chores...!", "this is a description for chores", -2));

    /// careful w.r.t destructors. also use id when actually doing. can add same activity multiple times....
    _selectedActivities.add(_activities[1]);

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

    Widget viewSection = CustomScrollView(
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

/*class InkWellColor extends StatefulWidget{
  final bool _isSelected;
  VoidCallback _onTap;
  InkWellColor(this._isSelected, this._onTap);

}

class InkWellColorState extends State<InkWellColor>{

  @override
  Widget build(BuildContext context) {
    child: new InkWell(
      onTap: widget._ontap,
      );
  }
  new InkWellColor(false, () => onTap());
*/

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapboxB(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

class TapboxB extends StatelessWidget {
  TapboxB({Key key, this.active: false, @required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}
