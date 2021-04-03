
import 'package:fit_app/fitness_app_anim.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fitness_app_home_screen.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:permission_handler/permission_handler.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.activityRecognition.status;
  print(status);
  if (status.isDenied || status.isUndetermined) {
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    Map<Permission, PermissionStatus> statuses = await [
    Permission.activityRecognition,
    ].request();
  }

  final responses = await FitKit.hasPermissions([
    DataType.DISTANCE,
    DataType.STEP_COUNT, 
    DataType.ENERGY,
  ]);
  if (!responses) {
    await FitKit.requestPermissions([
    DataType.DISTANCE,
    DataType.STEP_COUNT, 
    DataType.ENERGY,
    ]);
  }
  await Firebase.initializeApp();
  var user  = FirebaseAuth.instance.currentUser;
      if (user == null) {
          runApp(FitnessAppAnim());

      } else 
      {
        runApp(FitnessAppHomeScreen(selected: 0));
      }

}
