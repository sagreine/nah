import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nah/app/list.dart';
import 'package:nah/app/today.dart';
import 'package:nah/app/detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/settings.dart'; // remove once no pass blank Activity..
import 'package:nah/app/singletons.dart';
import 'package:nah/app/activity.dart';

// pls no do this, when this is not what this means. just do it right.
enum ScreenIndex { detail, list, today }

class FABController {
  void Function() onFab;
}

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final PageController _pageController = PageController(
    initialPage: ScreenIndex.list.index,
    //viewportFraction: 0.95,
    keepPage: true,
  );
  final FABController _listFabController = FABController();
  final FABController _detailFabController = FABController();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  //what page do we want to start on
  int bottomSelectedIndex = ScreenIndex.list.index;
  /*
  // instead of string, generate a list of valid screens?
  // way overkill for now in any case...
  int generateIndex(String page) {
    switch (page) {
      case '/':
        return Home();
      case '/feed':
        return MaterialPageRoute(builder: (_) => Feed());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
*/
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

  // but do we want a different icon for Detail[add new] vs Detail[edit] ?
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

  FloatingActionButtonLocation buildFABlocation() {
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

  void buildFABOnPressed() {
    // detail
    // context aware? was this a hero or an Add activity screen
    // orrrr do we make a new Add screen that just displays a detail UI screen?

    // list
    if (bottomSelectedIndex == ScreenIndex.list.index) {
      SnackBar snack = SnackBar(
        content: Text("Added these to your day!"),
        elevation: 8,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
        /*action: SnackBarAction(
          // TODO: undo add to day
          label: 'Undo',
          onPressed: () {},
        ),*/
      );

      //Scaffold.of(context).showSnackBar(snack);
      scaffoldState.currentState.showSnackBar(snack);
      _listFabController.onFab();

      // add this selection to Today then clear selected
      // this is abuse of a lot of things and dangerous -> would need to enforce only one ourList (list) to rely on this....
      // routing and creating a new one and handling it within that class is a much safer way to do this (and internal list of selectedActivities is way better)
      // this is fine for a very simple app i guess though. but i'll probably just use routing in the future.

    }

    // detail
    else if (bottomSelectedIndex == ScreenIndex.detail.index) {
       // snackbaer
       _detailFabController.onFab();
       // return to the list page -> do we always want this? or just for now
       // and later change if we get a hero animation from the timeline page
       bottomTapped(ScreenIndex.list.index);
    }


    //
    // today
  }

  Widget buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      // for sustainability, tie this and the enum together explicitly not this "trust me" nonsense ...
      children: <Widget>[
        DetailScreen(
          activity: Activity(
            'assets/images/default.jpg',
            "Add a title to this activity",
            "Add a subtitle to this activity",
            "Add an activity description!",
            0,
            //activity: null, // the rightest way but annoying to handle in detail
          ),
          controller: _detailFabController,          
        ),
        // this doesn't initialize though? apparently not given FAB push is broken
        ListScreen(controller: _listFabController),
        TodayScreen(),
      ],
    );
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
/*
          Navigator.push(
            context,
            AwesomePageRoute(
              transitionDuration: Duration(milliseconds: 600),
              exitPage: widget,
              enterPage: TodayScreen(),
              transition: CubeTransition(),
            ),
*/
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
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
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
      floatingActionButton: Container(
        height: 80,
        width: 90,
        child: FloatingActionButton(
          onPressed: () {
            buildFABOnPressed();
          },
          tooltip: 'Add to Day',
          child: buildFABIcon(),
          elevation: 12,
        ),
      ),
      floatingActionButtonLocation: buildFABlocation(),
    );
  }
}

