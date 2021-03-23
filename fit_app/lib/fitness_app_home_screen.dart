import 'package:fit_app/models/tabIcon_data.dart';
import 'package:fit_app/my_profile/myprofile_screen.dart';
import 'package:fit_app/training/training_screen.dart';
import 'package:fit_app/ui_view/add_food.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fitness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
void main() => runApp(new FitnessAppHomeScreen());

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  var protein, carbs, fat, watersofar, lastdrink, breakfast;
  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );
  Future<void> addToday(var today) async {
    User user = FirebaseAuth.instance.currentUser;
    String userid = user.uid;
    FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten")      
      .set({
        'drinken':0,
        'carbs' : 0,
        'protein' : 0,
        'fat' : 0,
        'eaten' : 0,
        'watersofar' : 0,
        'lastdrink' : 0,
        'lunch' : 0,
        'snacks' : 0,
        'dinner' : 0,
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").child("breakfast")      
      .set({
        "data":""
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").child("launch")      
      .set({
        "data":""
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").child("dinner")      
      .set({
        "data":""
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").child("snacks")      
      .set({
        "data":""
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));


      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("burned")      
      .set({
        "data": ""
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
    }      



  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
    duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyDiaryScreen(animationController: animationController);

    super.initState();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String today = formatter.format(now);
    var userid =  FirebaseAuth.instance.currentUser.uid;
    // check for existance
    FirebaseDatabase.instance.reference().child('users').child("$userid").
    child("food").child("$today").once().
    then((DataSnapshot snapshot){
      var value = snapshot.value;
      if(value == null)
      {
        addToday(today);
      }
      else
      {
      carbs = value["carbs"].toString();
      protein = value["protein"].toString();
      fat = value["fat"].toString();
      watersofar = value["watersofar"].toString();
      lastdrink = value["lastdrink"].toString();
      breakfast = value["breakfast"].toString();
      }
    });

  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

return MaterialApp(
      color: FitnessAppTheme.darkBackground,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
                
            },
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController);
                });
              });
            } else if (index == 1 || index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
            else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  
                  tabBody =
                    ProfileScreen(
                      animationController: animationController
                    );

                });
              });
            }
            else if (index == 4) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                    FoodPage();
                });
              });
            }
          }
        ),
      ],
    );
  }
}
