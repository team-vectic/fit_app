import 'package:fit_app/Screens/Welcome/welcome_screen.dart';
import 'package:fit_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class FitnessAppAnim extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome To FitApp',
      home: Scaffold(
        body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/fitness_app/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: MyRiveAnimation()
      ),
      )
    );
  }
}

class MyRiveAnimation extends StatefulWidget {
  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  final riveFileName = 'lib/assets/fitness_app/openinganim.riv';
  Artboard _artboard;

   launchURL(String url) async {
    if (!url.contains("http")) url = 'https://$url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
 }
  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => WelcomeScreen()
      )
  );
  }
  startTime() async {
  var duration = new Duration(seconds: 6);
  return new Timer(duration, route);

  }

  @override
  void initState() {
    _loadRiveFile();
    startTime();
    super.initState();
  }
  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('idle'),
        ));
    }
  }

  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
        width: 300,
        height: 300,
        child:_artboard != null
        ? Rive(
            artboard: _artboard,
            fit: BoxFit.fitWidth,
            )
        :SizedBox(),
        ),
      InkWell(
        child:
          Text("Please support us and join our Discord server- ",  style: TextStyle(color: FitnessAppTheme.white, fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          onTap: () {
            //  discord.com/invite/Dwv2TdNAnn
            launchURL("https://discord.com/invite/Dwv2TdNAnn");
          },
      ),
      SizedBox(height: 50),
      Text("Terms & Agreements", style: TextStyle(color: FitnessAppTheme.white, fontSize: 20))
      ],
    );
    
  }
}
