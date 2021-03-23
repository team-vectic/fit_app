import 'dart:async';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../fitness_app_theme.dart';

class AddWorkout extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const AddWorkout({Key key, this.animationController, this.animation})
      : super(key: key);


  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
    List<String> selectedActivities = [];
     List<String> activities = [
        "Walk - 99",
        "Running - 83",
        "Cycling - 290",
        "Eliptical - 100",
        "Rower - 120",
        "Stair Stepper - 130",
        "HIIT - 150",
        "Hiking - 185",
        "Yoga - 105",
        "Functional Strength Training - 81",
        "Dance - 22",
        "Core Training - 2390",
        "Swimming - 290",
        "Wheelchair - 2",
        "Slackline - 190"
      ];

 
  @override
  void initState() { 
    selectedActivities = [];
    super.initState();
  }
  
  void appendAddWorkout(){

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
        backgroundColor: FitnessAppTheme.darkBackground,
        title: Text('Add Workout', style: TextStyle(color: Colors.white),),
        content: Container(
        width: 500,
        height: 900,
        child: ListView(
          children: 
        List<Widget>.generate(
        activities.length,
        (int index) {
          return Container(
            padding: EdgeInsets.all(0),
            child: Item(index: index, selectedActivities: selectedActivities, activities: activities,)
          );
        }
        ),
        )
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(false); // dismisses only the dialog and returns false
                          selectedActivities = [];

            },
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              var now = new DateTime.now();
              var formatter = new DateFormat('yyyy-MM-dd');
              String today = formatter.format(now);
              var userid =  FirebaseAuth.instance.currentUser.uid;
              String latestValue = "";
              FirebaseDatabase.instance.reference().child('users').child("$userid").
              child("food").child("$today").child("burned").once().
              then((DataSnapshot snapshot){
                var value = snapshot.value;
                if(value != null){
                  latestValue = value["data"];
                  print(latestValue);

                  String selectedString = ""; 
                  selectedActivities.forEach((element) {
                    selectedString = selectedString + element.toString();
                    selectedString += " , ";
                  });
                  if (selectedString != null && selectedString.length >= 3) {
                    selectedString = selectedString.substring(0, selectedString.length - 3);
                  }
                  FirebaseDatabase.instance.reference().child('users').child("$userid").
                  child("food").child("$today").child("burned").update({
                    "data" : latestValue != "" ? latestValue + " , " + selectedString : selectedString 
                  }); 
                
                }
              
              });

            } ,
            child: Text('Confirm')
          )
        ],
        );
      });
  });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(

                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 14, bottom: 0),
                  child: InkWell(
                   child: Container(
                    width: 60,
                    height: 60,
                    child: Icon(Icons.add, size: 20, color: Colors.white,),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FitnessAppTheme.nearlyDark,
                        ),
                  ),
                   onTap: () {
                     appendAddWorkout();
                    },
                  )
                  
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Count extends StatefulWidget {
  int countI = 0; 
  Count({Key key, countI}) : super(key: key);

  @override
  _CountState createState() => _CountState();
}

class _CountState extends State<Count> {

 
 @override
 void initState() { 
   super.initState();

 }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
            children: <Widget>[
              InkWell(
                child: Icon(Icons.arrow_drop_up, color: Colors.white, size: 18),
                onTap: () {
                  setState(() => widget.countI = widget.countI + 30);
                  },
              ),
              Text('${widget.countI}', style: TextStyle(color: Colors.white, fontSize: 10)),
              Text('min', style: TextStyle(color: Colors.white, fontSize: 10)),
              InkWell(
                child: Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                onTap: () {
                  setState(() => widget.countI > 0 ? widget.countI = widget.countI - 30 : 0);
                  },
              ),
            ],
      )
    );
  }
}

class Item extends StatefulWidget {
  final int index; 
  final List<String> activities;
  final List<String> selectedActivities; 
  Item({@required this.index, @required this.selectedActivities, @required this.activities});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
    bool _selected = false;
  var splitted; 
  var count = Count();
  @override
  void initState() { 
    super.initState();
    try {
      splitted = widget.activities[widget.index].toString().split(" - ");
    } catch (e) 
    {
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      child: InkWell(
            onTap: () 
            {
              setState(() => 
                  _selected = !_selected
              );
              if(_selected){
                if (count.countI != 0) {
                  var temp = (count.countI.toInt()/60) * (int.tryParse(splitted[1]));
                  widget.selectedActivities.add(
                    '${splitted[0]} - $temp',
                  );
                }
              }
              else
              {
                try {
                  widget.selectedActivities.remove(
                    widget.selectedActivities[widget.index],
                  );
                } catch (e) {
                }
              }

            },
            child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Container(
              child: ListTile(
                title: Text(splitted[0], style: TextStyle(color: Colors.white)),
                subtitle: Text('${splitted[1]} calories per hour', style: TextStyle(color: Colors.white)),
                leading: count
                

            ),
            decoration:
                BoxDecoration(
                    color: FitnessAppTheme.nearlyDark,
                    border: 
                    Border.all(
                          width: _selected == true ? 1.8 : .5,
                          color: _selected == true ? Colors.amber : Colors.white
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //                 <--- border radius here
                    ))
            )

          ),
          )
          );
  }
}