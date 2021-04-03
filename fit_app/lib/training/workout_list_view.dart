import 'package:fit_app/fitness_app_theme.dart';
import 'package:fit_app/models/workouts_list_data.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class WorkoutListView extends StatefulWidget {
  const WorkoutListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  WorkoutListViewState createState() => WorkoutListViewState();
}

class WorkoutListViewState extends State<WorkoutListView> with TickerProviderStateMixin {
  List<String> rawList;

  void getWorkoutList(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String today = formatter.format(now);
    var userid = FirebaseAuth.instance.currentUser.uid;
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("burned").once().
      then((DataSnapshot snapshot){
      var value = snapshot.value;
      if(value != null)
      {
        rawList = value["data"].split(",");
        if (rawList.length != 0)
        {
          rawList.forEach((element) {
             
             
             var splitted = element.toString().split(" - ");
            try {
                var imagePath = getPath(splitted[0].replaceAll(" ", ""));
                workoutListData.add(
                Workout(
                    titleTxt: splitted[0].startsWith(" ") ? splitted[0].replaceRange(0 , 1 , "") : splitted[0],
                    calories: double.tryParse(splitted[1]),
                    imagePath: imagePath 
                ),
              );

            } catch (e) {
            }

          });    

        }}
        else
        {
          print("data is null");
        }
      });
  }

  AnimationController animationController;
  List<Workout> workoutListData = [];
  
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    getWorkoutList();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }
  getPath(var title) {
      switch (title.toString().toLowerCase()) {
        case "walk":
          return 'lib/assets/fitness_app/activities/walk.png';
          break;
        case "running":
          return 'lib/assets/fitness_app/activities/running.png';
          break;
        case "cycling":
          return 'lib/assets/fitness_app/activities/cycling.png';
          break;
        case "eliptical":
          return 'lib/assets/fitness_app/activities/eliptical.png';
          break;
        case "rower":
          return 'lib/assets/fitness_app/activities/rower.png';
          break;
        case "stairstepper":
          return 'lib/assets/fitness_app/activities/stairstepper.png';
          break;
        case "hiit":
          return 'lib/assets/fitness_app/activities/hiit.png';
          break;
        case "hiking":
          return 'lib/assets/fitness_app/activities/hiking.png';
          break;
        case "yoga":
          return 'lib/assets/fitness_app/activities/yoga.png';
          break;
        case "functionalstrengthtraining":
          return 'lib/assets/fitness_app/activities/functional.png';
          break;
        case "dance":
          return 'lib/assets/fitness_app/activities/dance.png';
          break;
        case "coretraining":
          return 'lib/assets/fitness_app/activities/coretraining.png';
          break;
        case "swimming":
          return 'lib/assets/fitness_app/activities/swimming.png';
          break;
        case "wheelchair":
          return 'lib/assets/fitness_app/activities/wheelchair.png';
          break;
        case "slackline":
          return 'lib/assets/fitness_app/activities/slackline.png';
          break;
      }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 300,
              width: 500,
              child: workoutListData.length != 0 ? 
              Padding(
              padding: EdgeInsets.all(8),
              child:
              ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: workoutListData.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      workoutListData.length > 10 ? 10 : workoutListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return WorkoutsView(
                    workoutListData: workoutListData[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              )) : workoutListData != null ?             
               SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "🏃",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 66,
                                letterSpacing: 0.2,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: 
                                    Text(
                                      "Pretty sad here... Maybe workout?",
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        letterSpacing: 0.1,
                                        color: FitnessAppTheme.white,
                                      ),
                                    )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyDark.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 5,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                    ),
                  )
                ],
              ),
            ) : Container()
            )
          ) 
        );
      },
    );
  }

}

class WorkoutsView extends StatelessWidget {
  const WorkoutsView(
      {Key key, this.workoutListData, this.animationController, this.animation})
      : super(key: key);

  final Workout workoutListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child:  SizedBox(
              width: 330,
              height: 170,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyDark,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: (FitnessAppTheme.darkBackground)
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              workoutListData.titleTxt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            workoutListData.calories != 0
                                ?  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        workoutListData.calories.toInt().toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 23,
                                          letterSpacing: 0.2,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 3),
                                        child: Text(
                                          'calories',
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 0.2,
                                            color: FitnessAppTheme.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyDark.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 5,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(workoutListData.imagePath),
                    ),
                  )
                ],
              ),
            )
          ),
        );
      },
    );
  }
}
