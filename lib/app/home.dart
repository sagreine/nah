import 'package:flutter/material.dart';

// borrowed here: https://github.com/syonip/flutter_login_video/blob/master/lib/sign_in.dart

enum ScreenIndex { detail, list, today }

/*
List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.edit), title: Text("Create Activity")),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.truckPickup),
          title: Text("Pick Activities")),
      BottomNavigationBarItem(
        icon: Icon(Icons.view_day),
        title: Text("View Today"),
        // pass _activitiesToAdd...?
      ),
    ];
  }

  Icon buildFABIcon() {
    if (bottomSelectedIndex == ScreenIndex.list.index) {
      // list icon
      return Icon(Icons.add);
      // detail icon
    } else if (bottomSelectedIndex == ScreenIndex.detail.index) {
      return Icon(Icons.done);
      // today icon
    } else {
      return Icon(FontAwesomeIcons.arrowLeft);
    }
  }

  FloatingActionButtonLocation buildFABlocation ()
  {
    if (bottomSelectedIndex == ScreenIndex.list.index) {
      // list icon
      return FloatingActionButtonLocation.centerDocked;
      // detail icon
    } else if (bottomSelectedIndex == ScreenIndex.detail.index) {
      return FloatingActionButtonLocation.centerFloat;
      // today icon
    } else {
      return FloatingActionButtonLocation.endFloat;
    }

  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    if ((bottomSelectedIndex - index).abs() == 1) {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _pageController.jumpToPage(index);
    }
  }


appBar: AppBar(
        title: Text("nah. a to-do-less app"),
        leading: Padding(
          padding: EdgeInsets.all(3),
          child: Image.asset("assets/images/ic_launcher.png"),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => Settings()),
              );
            },
          ),
        ],
      ),

 bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),


            Navigator.push(
        context,
        AwesomePageRoute(
          transitionDuration: Duration(milliseconds: 600),
          exitPage: widget,
          enterPage: TodayScreen(),
          transition: ParallaxTransition(),

void _navDetail() async {
      final result = await Navigator.push(
          context,
          // Create the SelectionScreen in the next step.
          MaterialPageRoute(
            builder: (context) => DetailScreen(
                activity: Activity(
              'assets/images/default.jpg',
              "Add a title to this activity",
              "Add a subtitle to this activity",
              "Add an activity description!",
              0,
            )),
          ));
      if (result != null) {
        setState(() {
          _activities.add(result);
        });
      }
    }      


  */

class MyHome extends StatefulWidget {
  MyHome({Key, key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
            ],
          ),
        ),
      ),
    );
  }
}