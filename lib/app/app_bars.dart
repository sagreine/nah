import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nah/app/settings.dart';

enum ScreenIndex { detail, list, today }

/*

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



appBar: 

 bottomNavigationBar: 


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

class BottomAppNah {
  int bottomSelectedIndex;

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
      ),
    ];
  }


  void pageChanged(int index) {
    //setState(() {
      bottomSelectedIndex = index;
    //});
  }

  void bottomTapped(int index) {
    // could have swithc for named routing here...
    if ((bottomSelectedIndex - index).abs() == 1) {
      //_pageController.animateToPage(index,
        //  duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      //_pageController.jumpToPage(index);
    }
  }

   getBottomNavBar(int bottomSelectedIndex) {
    return BottomNavigationBar(
      currentIndex: bottomSelectedIndex,
      onTap: (index) {
        bottomTapped(index);
      },
      items: buildBottomNavBarItems(),
    );
  }


}

class AppBarNah {
// this never changes so it can go in a static class
  static getAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      //title: Text("nah. a to-do-less app"),
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
    );
  }
}