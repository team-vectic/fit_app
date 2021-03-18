
import 'package:flutter/material.dart';
import 'package:fit_app/Screens/Login/login_screen.dart';
import 'package:fit_app/Screens/Signup/components/background.dart';
import 'package:fit_app/Screens/Signup/components/or_divider.dart';
import 'package:fit_app/Screens/Signup/measurements.dart';

import 'package:fit_app/components/already_have_an_account_acheck.dart';
import 'package:fit_app/components/rounded_button.dart';
import 'package:fit_app/components/rounded_input_field.dart';
import 'package:fit_app/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class Body extends StatelessWidget {
     Future<void> addUser(email, password, userid, context) {
      FirebaseDatabase.instance.reference().child('users').child("$userid")
      .set({
        'email': email,
        'password':password
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Measurements())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
    }
      FirebaseAuth auth = FirebaseAuth.instance;

      Future<void> signUp(email, password, context) async {
       try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
        addUser(email, password, auth.currentUser.uid, context);
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
  @override
  Widget build(BuildContext context1) {
    
  
    var mycontext = context1;
    String email = "";
    String password = "";
    Size size = MediaQuery.of(context1).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              
            ),
            SizedBox(height: size.height * 0.03),
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
            RoundedButton(
              text: "Next",
              press: () {
                signUp(
                email, password, mycontext);
              },
            ),
            SizedBox(height: size.height * 0.03),
            OrDivider(),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context1,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
