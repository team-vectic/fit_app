import 'package:fit_app/fitness_app_anim.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fitness_app_home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  var user  = FirebaseAuth.instance.currentUser;
      if (user == null) {
          runApp(FitnessAppAnim());

      } else 
      {
        runApp(FitnessAppHomeScreen());
      }

}
