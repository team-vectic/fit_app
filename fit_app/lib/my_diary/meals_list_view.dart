import 'package:fit_app/fitness_app_theme.dart';
import 'package:fit_app/models/meals_list_data.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class MealsListView extends StatefulWidget {
  const MealsListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView>
    with TickerProviderStateMixin {
      List<String> breakfast, launch, dinner, snacks; 

  void getMealList(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String today = formatter.format(now);
    var userid = FirebaseAuth.instance.currentUser.uid;
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").child("breakfast").once().
      then((DataSnapshot snapshot){
      var value = snapshot.value;
      if(value != null)
      {
        breakfast = value["data"].split(",");
        var kcal = breakfast.last;
        var intKcal;  
        try {
        intKcal = int.parse(kcal);
        } on FormatException {
        }
        breakfast.removeLast();
        if (breakfast.length != 0)
        {
          mealsListData.add(
          MealsListData(
              imagePath: 'lib/assets/fitness_app/breakfast.png',
              titleTxt: 'Breakfast',
              kacl: intKcal,
              meals: breakfast,
              startColor: '#FA7D82',
              endColor: '#FFB295',
            ),
          );

        }
      }
      });
      if(FirebaseAuth.instance.currentUser != null){
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").child("launch").once().
      then((DataSnapshot snapshot){
      var value = snapshot.value;
      if(value != null)
      {
        launch = value["data"].split(",");    
        var kcal = launch.last;
        var intKcal; 
        try {
        intKcal = int.parse(kcal);
        } on FormatException {
        }
        launch.removeLast();
        if(launch.length != 0){
        mealsListData.add(
          MealsListData(
            imagePath: 'lib/assets/fitness_app/lunch.png',
            titleTxt: 'Lunch',
            kacl: intKcal,
            meals: launch,
            startColor: '#738AE6',
            endColor: '#5C5EDD',
          ),
        );
        }
        }
      });
    
    }
      FirebaseDatabase.instance.reference().child('users').child("$userid").
            child("food").child("$today").child("eaten").child("dinner").once().
            then((DataSnapshot snapshot){
            var value = snapshot.value;
            if(value != null)
            {

              dinner = value["data"].split(",");
              var kcal = dinner.last;
              var intKcal; 

              dinner.removeLast();
              try {
              intKcal = int.parse(kcal);
              } on FormatException {
              }
              if(dinner.length != 0){
              mealsListData.add(
                MealsListData(
                  imagePath: 'lib/assets/fitness_app/dinner.png',
                  titleTxt: 'Dinner',
                  kacl: intKcal,
                  meals: dinner,
                  startColor: '#6F72CA',
                  endColor: '#1E1466',
                ),
              );
              }
            }

      });
      FirebaseDatabase.instance.reference().child('users').child("$userid").
      child("food").child("$today").child("eaten").child("snacks").once().
      then((DataSnapshot snapshot){
      var value = snapshot.value;
      if(value != null)
      {
        snacks = value["data"].split(",");
        var kcal = snacks.last;
        var intKcal; 
        snacks.removeLast();
        try {
        intKcal = int.parse(kcal);
        } on FormatException {
        }
        if(snacks.length != 0){
        mealsListData.add(
          MealsListData(
            imagePath: 'lib/assets/fitness_app/snack.png',
            titleTxt: 'Snacks',
            kacl: intKcal,
            meals: snacks,
            startColor: '#FE95B6',
            endColor: '#FF5287',
          ),
        );
        }
      }
      });

  }

  AnimationController animationController;
  List<MealsListData> mealsListData = [];
  
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    getMealList();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
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
              height: 216,
              width: double.infinity,
              child: mealsListData.length != 0 ? 
              ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: mealsListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();


                  return MealsView(
                    mealsListData: mealsListData[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ) :              
               SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "🤔",
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
                                      "Pretty lonely here... Maybe eat something?",
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
            ),
            )
          )
            
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData mealsListData;
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
            child: mealsListData.kacl != null ? SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(mealsListData.endColor)
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(mealsListData.startColor),
                            HexColor(mealsListData.endColor),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
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
                              mealsListData.titleTxt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: mealsListData.meals != null ? 
                                    Text(
                                      mealsListData.meals.join("\n"),
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.1,
                                        color: FitnessAppTheme.white,
                                      ),
                                    ) : 
                                    Text("")
                                    )
                                  ],
                                ),
                              ),
                            ),
                            mealsListData.kacl != 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        mealsListData.kacl.toString(),
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
                                          'kcal',
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
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: FitnessAppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: FitnessAppTheme.nearlyBlack
                                                .withOpacity(0.4),
                                            offset: Offset(8.0, 8.0),
                                            blurRadius: 8.0),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.add,
                                        color: HexColor(mealsListData.endColor),
                                        size: 24,
                                      ),
                                    ),
                                  ),
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
                      width: 80,
                      height: 80,
                      child: Image.asset(mealsListData.imagePath),
                    ),
                  )
                ],
              ),
            ) : 
            Container()
          ),
        );
      },
    );
  }
}
