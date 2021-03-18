
import 'dart:io';

import 'package:fit_app/ui_view/wave_view.dart';
import 'package:fit_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
class WaterView extends StatefulWidget {

  const WaterView(
      {Key key, this.mainScreenAnimationController,this.linearGradient, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final LinearGradient linearGradient;
  @override
  _WaterViewState createState() => _WaterViewState();
}

class _WaterViewState extends State<WaterView> with TickerProviderStateMixin {
  var watergoal, watersofar, lastdrink;
  final String defaultLocale = Platform.localeName;
  void updateWater(var action, var userid){
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String today = formatter.format(now);

      if(action == "+" && watersofar >= 0){
        setState(() {
          watersofar += 100; 
          FirebaseDatabase.instance.reference().child('users').child("$userid").child("food").
          child("$today").child("eaten").update({
            "watersofar" : watersofar,
            "lastdrink": DateFormat('hh:mm a', defaultLocale).format(DateTime.now())
          });
          getFirebaseData();

        });
      }
      if(action == "-" && watersofar > 0){
        setState(() {
          watersofar -= 100; 
          FirebaseDatabase.instance.reference().child('users').child("$userid").child("food").
          child("$today").child("eaten").update({
            "watersofar" : watersofar
          });
          getFirebaseData();

        });
      }
  }


  void getFirebaseData()
  {
      var userid =  FirebaseAuth.instance.currentUser.uid;
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String today = formatter.format(now);


      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("bodydata").once().
      then((DataSnapshot snapshot){
      var value = snapshot.value;
      if(value != null)
      {
        watergoal = value['watergoal'];
      }
      });
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").once().
      then((DataSnapshot snapshot){
      var value = snapshot.value;
      if(value != null)
      {
        watersofar = value['watersofar'];
        lastdrink = value['lastdrink'];
      }
      });
  }

  @override
  void initState() { 
    super.initState();
    getFirebaseData();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getFirebaseData());
  }
  
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.nearlyDark,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 3),
                                      child: Text(
                                        '$watersofar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 32,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 8),
                                      child: Text(
                                        'ml',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: -0.2,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, top: 2, bottom: 14),
                                  child: Text(
                                    'Out of $watergoal L',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 8, bottom: 16),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.background,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.access_time,
                                          color: FitnessAppTheme.white,
                                          size: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          lastdrink != 0 ? 
                                          'Last drink $lastdrink' : "You Didn't Drinked Yet",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.white
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 26),
                                    
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyDarkBlue
                                          .withOpacity(0.4),
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: (){updateWater("+", FirebaseAuth.instance.currentUser.uid);},
                                  child: Icon(
                                  Icons.add,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                  size: 24,
                                ),
                                )
                              ),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyDarkBlue
                                          .withOpacity(0.4),
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: (){updateWater("-", FirebaseAuth.instance.currentUser.uid);},
                                  child: Icon(
                                  Icons.remove,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                  size: 24,
                                ),
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 8, top: 16),
                        child: Container(
                          width: 60,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(232	,237,254,1),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80.0),
                                bottomLeft: Radius.circular(80.0),
                                bottomRight: Radius.circular(80.0),
                                topRight: Radius.circular(80.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.4),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4),
                            ],
                          ),
                          child: WaveView(
                            percentageValue: watersofar != null ? ((watersofar / 1000) / watergoal) * 100 : 0,
                            linearGradient: widget.linearGradient,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
