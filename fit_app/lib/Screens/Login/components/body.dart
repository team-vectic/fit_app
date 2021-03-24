import 'package:fit_app/Screens/Signup/components/or_divider.dart';
import 'package:fit_app/fitness_app_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_app/Screens/Login/components/background.dart';
import 'package:fit_app/Screens/Signup/signup_screen.dart';
import 'package:fit_app/components/already_have_an_account_acheck.dart';
import 'package:fit_app/components/rounded_button.dart';
import 'package:fit_app/components/rounded_input_field.dart';
import 'package:fit_app/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String email = "";
    String password = "";

    Future<void> signIn(exemail, expassword) async {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: exemail,
          password: expassword
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FitnessAppHomeScreen(selected: 0,);
              },
            ),
          );

          } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
          print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
}  
}
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: size.height * 0.03),
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
              text: "LOGIN",
              press: () {signIn(email, password);},
            ),
            SizedBox(height: size.height * 0.03),
            OrDivider(),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
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
