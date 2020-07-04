import 'package:flutter/material.dart';
import 'package:nah/app/list.dart';
import 'package:nah/app/today.dart';
import 'package:nah/app/detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/activity.dart'; // remove once no pass blank Activity..

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.8,
    keepPage: true,
  );
  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.edit), 
          title: Text("Create Activity")),
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

  Widget buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        /*
        DetailScreen(
            activity: null,
        ),*/
        ListScreen(),
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("nah. a to-do-less app"),
       ),
        
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
          ),
    );
  }
}

/*
   bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.blueGrey,
          notchMargin: 3.5,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                _currentIndex = index;
                // this will change when we add PageView
                // but, nav to the other screens this way basically
                if (_currentIndex == 1) {
                  _navToday();
                } else {
                  _navDetail();
                }
              },

              //_navigateToScreens(index);

              ),
        ),
        */
