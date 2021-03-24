import 'dart:async';
import 'dart:math';
import 'package:fit_app/bottom_navigation_view/bottom_bar_view.dart';
import 'package:fit_app/fitness_app_home_screen.dart';
import 'package:fit_app/models/tabIcon_data.dart';
import 'package:fit_app/ui_view/add_food.dart';
import 'package:fit_app/ui_view/body_measurement.dart';
import 'package:fit_app/ui_view/glass_view.dart';
import 'package:fit_app/ui_view/mediterranesn_diet_view.dart';
import 'package:fit_app/ui_view/title_view.dart';
import 'package:fit_app/fitness_app_theme.dart';
import 'package:fit_app/my_diary/meals_list_view.dart';
import 'package:fit_app/my_diary/water_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  Shader shaderLinearGradient;
  LinearGradient linearGradient;  
  List<LinearGradient> shaders = [
      LinearGradient(
      colors: <Color>[HexColor("#8E0E00"), HexColor("#b84f8b")],
      ),
      LinearGradient(
      colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
      ),
      LinearGradient(
      colors: <Color>[HexColor("#f46b45"), HexColor("#eea849")],
      ),
      LinearGradient(
      colors: <Color>[HexColor("#005C97"), HexColor("#363795")],
      ),
      LinearGradient(
      colors: <Color>[HexColor("#e53935"), HexColor("#e35d5b")],
      ),
      LinearGradient(
      colors: <Color>[HexColor("#2c3e50"), HexColor("#3498db")],
      )


  ];
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  var userid, eaten, burned, carbs, protein, fat, carbsgoal, fatgoal, proteingoal, caloriegoal; 
  var kcalleft, fatleft, carbsleft, proteinleft, angle;
  bool _isSelected = false;
  FirebaseAuth auth = FirebaseAuth.instance; 
  @override   
  void initState() {
          Random random = new Random();
          int randomNumber = random.nextInt(5) + 1; 
          shaderLinearGradient = shaders[randomNumber-1].createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
          linearGradient = shaders[randomNumber-1];
          topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: widget.animationController,
              curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

          scrollController.addListener(() {
            if (scrollController.offset >= 24) {
              if (topBarOpacity != 1.0) {
                setState(() {
                  topBarOpacity = 1.0;
                });
              }
            } else if (scrollController.offset <= 24 &&
                scrollController.offset >= 0) {
              if (topBarOpacity != scrollController.offset / 24) {
                setState(() {
                  topBarOpacity = scrollController.offset / 24;
                });
              }
            } else if (scrollController.offset <= 0) {
              if (topBarOpacity != 0.0) {
                setState(() {
                  topBarOpacity = 0.0;
                });
              }
            }
          });





      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String today = formatter.format(now);
      var userid =  FirebaseAuth.instance.currentUser.uid;
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").once().
      then((DataSnapshot snapshot){
        var value = snapshot.value;
        if(value != null)
        {
          eaten = value["eaten"];
          fat = value["fat"];
          protein = value["protein"];
          carbs = value["carbs"];

          FirebaseDatabase.instance.reference().child('users').child("$userid").
          child("food").child("$today").child("burned").once().
          then((DataSnapshot snapshot){
            var value = snapshot.value;
            if(value != null)
            {
              burned = value["burned"];
            }
          });
          FirebaseDatabase.instance.reference().child('users').child("$userid").
          child("bodydata").once().
          then((DataSnapshot snapshot){
            var value = snapshot.value;
            if(value != null)
            {
              caloriegoal = value["caloriegoal"];
              carbsgoal = value["carbsgoal"];
              fatgoal = value["fatgoal"];
              proteingoal = value["proteingoal"];
              kcalleft = caloriegoal - eaten;
              carbsleft = carbsgoal - carbs;
              fatleft = fatgoal - fat;
              proteinleft = proteingoal - protein;
              
              
                setState(() {
                    addAllListData();
                });
              

            }
          });

        }
      });


    super.initState();
  }

  void resetTodayData(){
   // TODO - Reset the overview tab; IDO
   
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String today = formatter.format(now);
    userid =  FirebaseAuth.instance.currentUser.uid;

    FirebaseDatabase.instance.reference().child('users').child("$userid").
    child("food").child("$today").child("eaten").child("breakfast")      
    .set({
      "data":""
    })
    .catchError((error) => print("Failed to add user: $error"));
    FirebaseDatabase.instance.reference().child('users').child("$userid").
    child("food").child("$today").child("eaten").child("launch")      
    .set({
      "data":""
    })
    .catchError((error) => print("Failed to add user: $error"));
    FirebaseDatabase.instance.reference().child('users').child("$userid").
    child("food").child("$today").child("eaten").child("dinner")      
    .set({
      "data":""
    })
    .catchError((error) => print("Failed to add user: $error"));
    FirebaseDatabase.instance.reference().child('users').child("$userid").
    child("food").child("$today").child("eaten").child("snacks")      
    .set({
      "data":""
    })
    .catchError((error) => print("Failed to add user: $error"));

    runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new FitnessAppHomeScreen(selected: 0,),
    ));


  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      TitleView(
        linearGradient: 
        shaderLinearGradient,
        titleTxt: 'Overview',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    if(carbs == 0){
      carbsleft = carbsgoal;
    }
    if(protein == 0){
      proteinleft = proteingoal;
      
    }
    if(fat == 0){
      fatleft = fatgoal;
    }

    listViews.add(
      MediterranesnDietView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController, 
        eaten: eaten, 
        burned: burned, 
        kcalleft: kcalleft, 
        carbsleft: carbsleft, 
        proteinleft: proteinleft, 
        fatleft: fatleft,
        eatengoal: caloriegoal, 
        carbsgoal: carbsgoal,
        proteingoal: proteingoal,
        fatgoal: fatgoal,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Meals today',
        subTxt: 'Reset',
        linearGradient: 
        shaderLinearGradient,
        subTap: () {
          resetTodayData();
        },
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      MealsListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        linearGradient: 
        shaderLinearGradient,
        titleTxt: 'Body measurement',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      BodyMeasurementView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      TitleView(
        linearGradient: 
        shaderLinearGradient,
        titleTxt: 'Water',
        subTxt: 'More about drinking times',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      WaterView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 7, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
        linearGradient: linearGradient
      ),
    );
    listViews.add(
      GlassView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.darkBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.nearlyDark.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'My Diary',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child:  InkWell(
                                child: Image.asset(_isSelected
                                ? "lib/assets/fitness_app/tab_adds.png"
                                : "lib/assets/fitness_app/tab_add.png"),
                                onTap: () {
                                  setState(() {
                                    _isSelected = !_isSelected;
                                  });
                                  Timer(Duration(milliseconds: 500), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FitnessAppHomeScreen(selected: 3)),
                                    );
                                  }); 

                                }
                              )
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }


}
