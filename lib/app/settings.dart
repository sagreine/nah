import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:nah/app/state_container.dart";

//https://stackoverflow.com/questions/49491860/flutter-how-to-correctly-use-an-inherited-widget/49492495#49492495

// may not really need the controller given this?

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // actually think about this before we do it....
  final _lifePointsController = TextEditingController();
  AppSettings appSettings;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _lifePointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    appSettings = container.appSettings;

    // only actually want this run once? or does flutter handle that (text == text, so no need to repaint?)
    // also probably just not the right way to do this at all but yeah.
    // not incorrect display, anyway
    // TODO: This is a default setting to not stop them in their tracks
    // could push them directly to settings page, snackbar them to, even a flyin widget to edit it.
    if (appSettings != null) {
      _lifePointsController.text = appSettings.lifePointsCeilling.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body:
          // get lifepoints if you want
          Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "LifePoints",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Text(
                "LifePoints determine how many activities you can do in a day " +
                    "based on how expensive (or restorative!) each activity is",
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: TextField(
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.greenAccent,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  ),
                  labelText: appSettings == null ? "Enter Your LifePoints" : "Edit Your LifePoints",
                ),
                //_allowedSore.toString()),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                controller: _lifePointsController,
                // update the global setting to the new value and print for debug
                // TODO: this will break things if, e.g., they've select 97 things for today already
                // and we're changing this to say 5. how will Today handle that? List?
                onSubmitted: (String value) {
                  container.updateAppSettings(int.parse(value));
                  print(container.appSettings.lifePointsCeilling.toString());
                  print(appSettings.lifePointsCeilling.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
