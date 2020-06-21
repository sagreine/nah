import 'package:flutter/material.dart';
import 'package:nah/app/activity.dart';
import 'package:nah/app/list.dart';

class MyApp extends StatelessWidget {
  @override
  //MyAppState createState() => MyAppState();
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome()
      );
  }
}

class MyHome extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold (
      body: Column(
        children: <Widget>[
          ButtonBar(children: <Widget>[
            FlatButton(
              
              autofocus: false,
              clipBehavior: Clip.none,
              //onPressed: () {print("presssed");},
              onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                          return Scaffold(
                            body: Container(
                                child:
                                    ListScreen()),
                          );
                        }),
                      );
                    },
                    child:
                    Text ("Go to detail page"),
            ),
          ],)
      ],
      ),
    ),
    );
      /*bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBarItem,),*/
      
    
  }
}