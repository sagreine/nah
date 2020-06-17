import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/detail.dart';

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Activity> _activities = List<Activity>();
  List<Activity> _selectedActivities = List<Activity>();

  @override
  Widget build(BuildContext context) {
    // this part obviously doesn't go here, done every build
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
      // may want a sliver app bar here ... and an 'add' button
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            // load from db up front or lazy here directly?
            // performance considerations.
            // use ListTile instead of card....
            return Card(
              // weight this color
              color: _activities[index].getLifePointsColor(),
              shadowColor: Theme.of(context).primaryColorDark,
              child: InkWell(
                splashColor: Theme.of(context).primaryColor.withAlpha(30),
                onTap: () {},
                onLongPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(activity: _activities[index])));
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _activities[index].img,
                      ),
                      Text(_activities[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          )),
                    ]),
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
                onPressed: () {/* ... */},
              ),
            ]),
        _buildViewSection(),
      ],
    );

    Widget todaySection() {
      return ListView.builder(itemBuilder: (context, i) {
        return ListTile(
          title: Text(
            _selectedActivities[i].title,
          ),
        );
      });
    }

    return MaterialApp(
      title: 'nah',
      home: Scaffold(
        appBar: AppBar(
          title: Text('nah. do less'),
        ),
        body: viewSection,
      ),
    );
  }
}
