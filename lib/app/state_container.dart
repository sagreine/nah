import 'package:flutter/material.dart';


/// this class passes around stateful data automatically when updated
/// can be thought of as used for replacing 
/// 'global variables' or 'static variables' in a fluttery way
/// taken from https://gist.github.com/ericwindmill/f790bd2456e6489b1ab97eba246fd4c6

class AppSettings {
  int lifePointsCeilling;

  AppSettings(this.lifePointsCeilling);

}

class _InheritedStateContainer extends InheritedWidget {
   // Data is your entire state. In our case just 'AppSettings' 
  final StateContainerState data;
   
  // You must pass through a child and your state.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
   // You must pass through a child. 
  final Widget child;
  final AppSettings appSettings;

  StateContainer({
    @required this.child,
    this.appSettings,
  });

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static StateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()
            ).data;
  }
  
  @override
  StateContainerState createState() => new StateContainerState();
}



class StateContainerState extends State<StateContainer> {
  // Whichever properties you wanna pass around your app as state
  AppSettings appSettings;

  // These methods are then used through our your app to 
  // change state.
  // Using setState() here tells Flutter to repaint all the 
  // Widgets in the app that rely on the state you've changed.
  void updateAppSettings(lifePointsCeiling) {
    if (appSettings == null) {
      appSettings = new AppSettings(lifePointsCeiling);
      setState(() {
        appSettings = appSettings;
      });
    } else {
      setState(() {
        appSettings.lifePointsCeilling = lifePointsCeiling ?? appSettings.lifePointsCeilling;
      });
    }
  }

  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}