import 'package:flutter/material.dart';
import 'package:nah/app/list.dart';
import 'package:nah/app/today.dart';
import 'package:nah/app/detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/settings.dart'; // remove once no pass blank Activity..

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



/*void _navToday() {
      Navigator.push(
        context,
        AwesomePageRoute(
          transitionDuration: Duration(milliseconds: 600),
          exitPage: widget,
          enterPage: TodayScreen(),
          transition: ParallaxTransition(),
        ),

        //MaterialPageRoute<void>(builder: (context) => TodayScreen()),
      );*/ 


    // push a new activity to detail screen and update the list of activities if you get one back
    // managed through e.g. PageView in future? (e.g., bottom nav bar navigation to Detail on Today needs very similar code to update _activities)
    // though with consideration of how exactly would you do that given you can go Today->new Detail. for now assume PageView has magic.
    // or _activities is singleton... or just manage it all from home since PageView creates them anyway.. -> use a builder if we want different
    // or just to learn how to do it...
/*    
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