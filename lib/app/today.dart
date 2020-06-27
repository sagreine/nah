import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';

///// needs to be a list, not a set, as activities can repeat here
/// needs order-ability
///  TODO: animatedList?
class TodayScreen extends StatelessWidget {
  //DetailScreen({Key key, @required this.activity}) : super(key: key);
  List<Activity> selectedActivities;
  TodayScreen({Key key, @required this.selectedActivities}) : super(key: key);

  @override
  Widget build(BuildContext context) {




    Widget _buildViewSection () {
      return ListView.builder(
      //shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: selectedActivities.length,
      itemBuilder: (BuildContext context, int index) {
        // populated card, detail screen on long press
        return Card(
          shadowColor: Theme.of(context).primaryColorDark,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor.withAlpha(30),
            onTap: () {
              //TODO: something? drag to reorder?
                          // how will we let them reorder if longpress does this.. maybe double replaces this tap?
            },
            onLongPress: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (BuildContext context) {
                  return Scaffold(
                    body: Container(
                        child:
                            DetailScreen(activity: selectedActivities[index])),
                  );
                }),
              );
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                // do we want these cards to be the same size? height? 
                // same as other page, same as each other, something else?
                children: [
                  //Expanded(
                    //child: 
                    selectedActivities[index].img,
                  //),
                  Text(selectedActivities[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.9),
                      )),
                ]
            ),
          ),
        );
      },
      //separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
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
      body: viewSection,
    ));
  }

  //@override
  //TodayScreenState createState() => TodayScreenState();

}

//class TodayScreenState extends State<TodayScreen> {
//List<Activity> selectedActivities;// = List<Activity>();
//TodayScreenState({Key key); //: super(Key, key);

//}
