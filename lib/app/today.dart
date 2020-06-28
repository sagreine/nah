import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';

///// needs to be a list, not a set, as activities can repeat here
/// TODO: retain reordering across life of screen (if i go back, then return, i want to save my order) --- this happens now, just not setState()...
/// TODO: obviously, this is no longer a stateless widget....
/// TODO: custom timeline rather than reorderable list? more fun :)
/// TODO: animated list? much more fun especially for deletion sweep :)
class TodayScreen extends StatelessWidget {
  //DetailScreen({Key key, @required this.activity}) : super(key: key);
  List<Activity> _selectedActivities;
  final List<Activity> addedActivities;

  TodayScreen({Key key, this.addedActivities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildViewSection() {
      //so this goes in initState..
      if (_selectedActivities == null) {
        _selectedActivities = List<Activity>();
      }
      
      print("this.addedActivities.length " + this.addedActivities.length.toString());
      // if we got passed new activities for today, add them!
      _selectedActivities.addAll(this.addedActivities);

      return ReorderableListView(
          //shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          onReorder: (_oldIndex, _newIndex) {
            //setState(() {
            Activity tmpOld = _selectedActivities.removeAt(_oldIndex);
            _selectedActivities.insert(_newIndex, tmpOld);
            //}
            //);
          },
          header: Text("Drag to reorder"),
          children: <Widget>[
            for (final activity in _selectedActivities)

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
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
                        onTap: () {
                          _selectedActivities.remove(activity);
                          print(_selectedActivities.length);
                        },
                      ),

                      //selectedActivities.removeAt(index),
                    ],
                  ),
                ),
              ),
          ]);
      //separatorBuilder: (BuildContext context, int index) => const Divider(),
    }

    Widget viewSection = GestureDetector(
      onPanUpdate: (details) {
        // swipe left to look at today
        if (details.delta.dx > 0) {
          Navigator.of(context).pop();
          /*Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => TodayScreen(selectedActivities: _selectedActivities)),*/
        }
        // should we async await then save? what if they change their mind...
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

  //@override
  //TodayScreenState createState() => TodayScreenState();

}

//class TodayScreenState extends State<TodayScreen> {
//List<Activity> selectedActivities;// = List<Activity>();
//TodayScreenState({Key key); //: super(Key, key);

//}
