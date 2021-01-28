import 'package:flutter/material.dart';
import 'package:fit_app/Screens/Login/login_screen.dart';
import 'package:fit_app/Screens/Signup/components/background.dart';
import 'package:fit_app/Screens/Signup/components/or_divider.dart';
import 'package:fit_app/fitness_app_home_screen.dart';

import 'package:fit_app/Screens/Signup/components/social_icon.dart';
import 'package:fit_app/components/already_have_an_account_acheck.dart';
import 'package:fit_app/components/rounded_button.dart';
import 'package:fit_app/components/rounded_input_field.dart';
import 'package:fit_app/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

      Future<void> signUp(email, password) async {
       try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    
  }

    String email = "";
    String password = "";
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
              
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "lib/assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {email=value;},
            ),
            RoundedPasswordField(
              onChanged: (value) {password=value;},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {signUp(email, password);},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
          ],
        ),
      ),
    );
  }
}
