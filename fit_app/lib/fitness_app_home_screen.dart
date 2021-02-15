import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_app/models/tabIcon_data.dart';
import 'package:fit_app/my_profile/my_profile.dart';
import 'package:fit_app/training/training_screen.dart';
import 'package:fit_app/ui_view/add_food.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fitness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
void main() => runApp(new FitnessAppHomeScreen());

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );
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
      addUserToday(today);

  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> addUserToday(var today) async {
    User user = FirebaseAuth.instance.currentUser;
    String userid = user.uid;
          CollectionReference users = FirebaseFirestore.instance.collection('users');
          return users
              .doc('$userid')
              .collection('$today')
              .add({
                'burned' : "", 
                'eaten' : "",
                'carbs' : "",
                'protein' : "",
                'fat' : "",
                'watersofar' : "",
                'lastdrink' : "",
                'breakfast' : "",
                'lunch' : "",
                'snacks' : "",
                'dinner' : "",
              })
              .then((value) =>       
                print('success')    
              )
              .catchError((error) => print("Failed to add user: $error"));


    
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
    );
  }

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
                    MyDiaryScreen();
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
