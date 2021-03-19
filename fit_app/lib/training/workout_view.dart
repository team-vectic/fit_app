import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../fitness_app_theme.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:intl/intl.dart';
class WorkoutView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const WorkoutView({Key key, this.animationController, this.animation})
      : super(key: key);


  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  var data, type; 
  Widget stepsWidget = Container();
  Widget distanceWidget = Container();
  Widget calorieWidget;

void readDistance() async {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      dateFrom = current.subtract(Duration(
        hours: current.hour,
        minutes: current.minute,
        seconds: current.second,
      ));
      dateTo = DateTime.now();
  try {
    final data = await FitKit.read(
      DataType.DISTANCE,
      dateFrom: dateFrom,
      dateTo: dateTo
    );

    double total = 0;

    for (FitData datasw in data) {
      total += datasw.value;
    }
    var totalstr = total.toStringAsFixed(2);
    if (this.mounted) {
      setState(() {
            distanceWidget = 
            Padding(
            padding:
                const EdgeInsets.only(
                    left: 4, top: 3),
            child: Text(
              '$totalstr',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily:
                    FitnessAppTheme
                        .fontName,
                fontWeight:
                    FontWeight.w600,
                fontSize: 16,
                color: FitnessAppTheme
                    .white,
              ),
            ),
          );
      });
    }
  } on UnsupportedException catch (e) {
    // thrown in case e.dataType is unsupported
  }
}
void readCalories() async {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      dateFrom = current.subtract(Duration(
        hours: current.hour,
        minutes: current.minute,
        seconds: current.second,
      ));
      dateTo = DateTime.now();
  try {
    final data = await FitKit.read(
      DataType.ENERGY,
      dateFrom: dateFrom,
      dateTo: dateTo
    );
    int total = 0;

    for (FitData datasw in data) {
      total += datasw.value.toInt();
    }
    if (this.mounted) {
      setState(() {
            calorieWidget = 
            Padding(
            padding:
                const EdgeInsets.only(
                    left: 4, top: 3),
            child: Text(
              '$total',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily:
                    FitnessAppTheme
                        .fontName,
                fontWeight:
                    FontWeight.w600,
                fontSize: 16,
                color: FitnessAppTheme
                    .white,
              ),
            ),
          );
      });
    }
  } on UnsupportedException catch (e) {
    // thrown in case e.dataType is unsupported
  }
}
void readSteps() async {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      dateFrom = current.subtract(Duration(
        hours: current.hour,
        minutes: current.minute,
        seconds: current.second,
      ));
      dateTo = DateTime.now();
  try {
    final data = await FitKit.read(
      DataType.STEP_COUNT,
      dateFrom: dateFrom,
      dateTo: dateTo
    );
    double total = 0; 
    for (FitData datasw in data) {
      total += datasw.value;
    }
    var totalstr = total.toStringAsFixed(2);
    if (this.mounted) {
      setState(() {
            stepsWidget = 
            Padding(
            padding:
                const EdgeInsets.only(
                    left: 4, top: 3),
            child: Text(
              '$totalstr',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily:
                    FitnessAppTheme
                        .fontName,
                fontWeight:
                    FontWeight.w600,
                fontSize: 16,
                color: FitnessAppTheme
                    .white,
              ),
            ),
          );
      });
    }
  } on UnsupportedException catch (e) {
    // thrown in case e.dataType is unsupported
  }
}
    
    
static List<T> map<T>({@required List list, @required Function handler}) {
    List<T> result = [];

    int lengthToDisplay =
        list.length;

    if (list.length > 0) {
      for (var i = 0; i < lengthToDisplay; i++) {
        result.add(handler(i, list[i]));
      }
    }

    return result;
  }
  
  @override
  void initState() {
   // readCalories();
    readDistance();
    readSteps();
    readCalories();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return 
    AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child:  Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.nearlyDark,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: stepsWidget  != null && distanceWidget  != null && calorieWidget != null ? Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4),
                              child: Column(
                                children: <Widget>[    
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: HexColor('#87A0E5')
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'Distance',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: FitnessAppTheme.white,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                distanceWidget,
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                  child: Text(
                                                    'Meters',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: FitnessAppTheme
                                                          .white
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: HexColor('#F56E98')
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'Calories Burned',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: FitnessAppTheme.white,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                calorieWidget,
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, bottom: 3),
                                                  child: Text(
                                                    'Kcal',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: FitnessAppTheme
                                                          .white
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                      ),
                                              
        
                                          ]
                                        ),
                                    ],
                                  )
                      
                              ),
                            ),
                    
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.amber
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 4),
                                              child: Text(
                                                'Steps Today',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: FitnessAppTheme.white,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, top: 3),
                                                  child: stepsWidget
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                  child: Text(
                                                    'Steps',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: FitnessAppTheme
                                                          .white
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                    ]
                                  ),
                                  )
                      
                              ),
          
                        ]
                      ) : CircularProgressIndicator()
                    )
                  ]
                ),
              ),
            ),
          ),
        );
        }
      );
  }
} 