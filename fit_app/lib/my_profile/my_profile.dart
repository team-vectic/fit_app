import 'package:fit_app/Screens/Welcome/welcome_screen.dart';
import 'package:fit_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MyProfile extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _signOut() async{
      await FirebaseAuth.instance.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    


  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      body: Stack(
        children: <Widget>[
          
            Padding(
            padding: EdgeInsets.only(left:size.width * 0.05, top: size.height * 0.1),
            child:Container(
              height: size.height * 0.35,
              width: size.width * 0.9 ,
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
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
              
            ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.10,top: size.height * 0.27),
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.005,
                decoration: BoxDecoration(
                  color: FitnessAppTheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
              Padding(
              padding:EdgeInsets.only(left:size.width * 0.1, top: size.height * 0.1),
              child:   
              Text(
                'Hi',
                style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.black87)
              ),

              ),
              Padding(
              padding:EdgeInsets.only(left:size.width * 0.29, top: size.height * 0.155),
              child:   
              Text(
                'Jacklin',
                style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.black87, fontSize: 25)
              ),
              ),
              Padding(
              padding:EdgeInsets.only(left:size.width * 0.13, top: size.height * 0.30),
              child:Text(
                'Walked',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: -0.2,
                  color: FitnessAppTheme.darkText,
                ),
              ),
              ),
              Padding(
                padding: EdgeInsets.only(left:size.width * 0.13, top: size.height * 0.34),
                child: Container(
                  height: 4,
                  width: 70,
                  decoration: BoxDecoration(
                    color: HexColor('#87A0E5')
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                        Radius.circular(4.0)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.width * 0.02,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [
                            HexColor('#87A0E5')
                                .withOpacity(0.1),
                            HexColor('#87A0E5'),
                          ]),
                          borderRadius: BorderRadius.all(
                              Radius.circular(4.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:size.width * 0.13, top: size.height * 0.355),
                child: Text(
                  '10 km',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: FitnessAppTheme.grey
                        .withOpacity(0.5),
                  ),
                ),
              ),
              Padding(
              padding:EdgeInsets.only(left:size.width * 0.39, top: size.height * 0.30),
              child:Text(
                'Calories',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: -0.2,
                  color: FitnessAppTheme.darkText,
                ),
              ),
              ),
              Padding(
                padding: EdgeInsets.only(left:size.width * 0.39, top: size.height * 0.34),
                child: Container(
                  height: 4,
                  width: 70,
                  decoration: BoxDecoration(
                    color: HexColor('#F56E98')
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                        Radius.circular(4.0)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.width * 0.02,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [
                            HexColor('#F56E98')
                                .withOpacity(0.1),
                            HexColor('#F56E98'),
                          ]),
                          borderRadius: BorderRadius.all(
                              Radius.circular(4.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:size.width * 0.39, top: size.height * 0.355),
                child: Text(
                  '100 Calories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: FitnessAppTheme.grey
                        .withOpacity(0.5),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left:size.width * 0.20, top: size.height * 0.485),
                child:  InkWell (
                onTap: (){
                _signOut();
                },
                child:Container(
                height: size.height * 0.08,
                width: size.width * 0.6 ,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                              colors: [
                                FitnessAppTheme.nearlyDarkBlue,
                                Color.fromRGBO(106, 136,	229, 1),
                  ],
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                      topRight: Radius.circular(50.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                  ),
                  child: Padding(padding: EdgeInsets.only(top: size.height * 0.010),
                    child:Text(
                    'Sign Out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: FitnessAppTheme.white
                          .withOpacity(1),
                    ),
                  ),

                  
                  ) 
              ),
                ),
              ),
            ],
          
      
      ),
    );
  }
}
