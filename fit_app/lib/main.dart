import 'package:fit_app/fitness_app_anim.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fitness_app_home_screen.dart';
import 'package:fit_kit/fit_kit.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final responses = await FitKit.hasPermissions([
    DataType.DISTANCE,
  ]);
  if (!responses) {
    await FitKit.requestPermissions([
      DataType.DISTANCE
    ]);
  }
  await Firebase.initializeApp();
  var user  = FirebaseAuth.instance.currentUser;
      if (user == null) {
          runApp(FitnessAppAnim());

      } else 
      {
        runApp(FitnessAppHomeScreen());
      }

}
