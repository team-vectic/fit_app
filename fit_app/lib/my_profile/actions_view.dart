import 'package:fit_app/Screens/Welcome/welcome_screen.dart';
import 'package:fit_app/components/rounded_input_field.dart';
import 'package:fit_app/components/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../fitness_app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';

class ActionView extends StatefulWidget {
  const ActionView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  @override
  ActionViewState createState() => ActionViewState();
}

class ActionViewState extends State<ActionView>
    with TickerProviderStateMixin {
  String email, password, nPassword; 
  AnimationController animationController;
  List<String> areaListData = <String>[
    'Change Password',
    'Delete Account',
    'Reset All Nutrition Goal',
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

    Future<void> newPassword(exemail, expassword, nPassword) async {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: exemail,
          password: expassword
          );
          _changePassword(nPassword);
          } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Flushbar(
              titleText: Text("No User Found", style: TextStyle(color: Colors.black),),
              message: " ",
              backgroundColor: FitnessAppTheme.nearlyWhite,
            ).show(context);
          } else if (e.code == 'wrong-password') {
            Flushbar(
              titleText: Text("Wrong password provided for that user.", style: TextStyle(color: Colors.black),),
              message: " ",
              backgroundColor: FitnessAppTheme.nearlyWhite,
            ).show(context);
        }
}  
}
    Future<void> signIn(exemail, expassword) async {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: exemail,
          password: expassword
          );
          showDialog(context: context, 
              builder:(BuildContext context) {
              // return object of type Dialog
                return AlertDialog(
                  backgroundColor: FitnessAppTheme.darkBackground,
                  title: new Text("Account Deletion", style: TextStyle(color: Colors.white),),
                  content:
                      new Text("Are you sure you want to delete your account?"),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Confirm", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                          var userid = FirebaseAuth.instance.currentUser.uid;
                          FirebaseDatabase.instance.reference().child('users').child("$userid")
                          .remove();
                          FirebaseAuth.instance.currentUser.delete();
                            runApp(
                              new MaterialApp(
                                debugShowCheckedModeBanner: false,
                                home: new WelcomeScreen(),
                            )
                            );


                      },
                    ),
                    new FlatButton(
                      child: new Text("Cancel", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
                            
              });
          } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
          print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
}  
}

  void _changePassword(String password) async{
    //Create an instance of the current user. 
     var user = FirebaseAuth.instance.currentUser;
    
      //Pass in the password to updatePassword.
      user.updatePassword(password).then((_){
        Navigator.of(context, rootNavigator: true)
        .pop(false); // dismisses only the dialog and returns false

        Flushbar(
          titleText: Text("Successfuly changed password!", style: TextStyle(color: Colors.black),),
          message: " ",
          backgroundColor: FitnessAppTheme.nearlyWhite,
        ).show(context);

      }).catchError((error){
        Flushbar(
          titleText: Text("Password can't be changed", style: TextStyle(color: Colors.black),),
          message: " ",
          backgroundColor: FitnessAppTheme.nearlyWhite,
        ).show(context);


        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
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
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List<Widget>.generate(
                    areaListData.length,
                    (int index) {
                      final int count = areaListData.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return AreaView(
                        name: areaListData[index],
                        function: (){
                          if (index == 0) {
                            showDialog(context: context, builder:  (_) => 
                            new AlertDialog(
                              backgroundColor: FitnessAppTheme.darkBackground,
                              title: new Text("Re-Authenticate",style: TextStyle(color: Colors.white),),
                              
                              actions: <Widget>[
                                RoundedInputField(
                                  icon: Icons.mail,
                                  hintText: "Email 📬",
                                  onChanged: (value) {email=value;},
                                ),
                                RoundedPasswordField(
                                  icon: Icons.lock,
                                  hintText: "Password 🔑",
                                  onChanged: (value) {password=value;},
                                ),
                                Row(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        
                                        Navigator.of(context, rootNavigator: true)
                                        .pop(false); // dismisses only the dialog and returns false

                                        showDialog(context: context, builder:  (_) => 
                                        new AlertDialog(
                                          backgroundColor: FitnessAppTheme.darkBackground,
                                          title: new Text("New Passowrd",style: TextStyle(color: Colors.white),),
                                          
                                          actions: <Widget>[
                                            RoundedPasswordField(
                                              icon: Icons.lock,
                                              hintText: "Password 🔑",
                                              onChanged: (value) {nPassword=value;},
                                            ),
                                            Row(
                                              children: <Widget>[
                                                FlatButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('Submit'),
                                                  onPressed: () {
                                                    
                                                    newPassword(email, password, nPassword);
                                                  },
                                                )

                                              ]
                                            )
                                          ],
                                        )
                                        );
                                      },
                                    )

                                  ]
                                )
                              ],
                            )
                            );
                          }
                          if (index == 1) {
                            showDialog(context: context, builder:  (_) => 
                            new AlertDialog(
                              backgroundColor: FitnessAppTheme.darkBackground,
                              title: new Text("Re-Authenticate",style: TextStyle(color: Colors.white),),
                              
                              actions: <Widget>[
                                RoundedInputField(
                                  icon: Icons.mail,
                                  hintText: "Email 📬",
                                  onChanged: (value) {email=value;},
                                ),
                                RoundedPasswordField(
                                  icon: Icons.lock,
                                  hintText: "Password 🔑",
                                  onChanged: (value) {password=value;},
                                ),
                                Row(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        signIn(email, password);
                                      },
                                    )

                                  ]
                                )
                              ],
                            )
                            );

                          }
                        },
                        animation: animation,
                        animationController: animationController,
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
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

class AreaView extends StatelessWidget {
  const AreaView({
    this.function,
    Key key,
    this.name,
    this.animationController,
    this.animation,
  }) : super(key: key);
  final Function function;
  final String name;
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
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: FitnessAppTheme.nearlyDark,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {
                      function();
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(name, style: TextStyle(
                          color: FitnessAppTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
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
