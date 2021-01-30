import 'package:flutter/material.dart';
import 'package:fit_app/Screens/Login/components/background.dart';
import 'package:fit_app/Screens/Signup/signup_screen.dart';
import 'package:fit_app/components/already_have_an_account_acheck.dart';
import 'package:fit_app/components/rounded_button.dart';
import 'package:fit_app/components/rounded_input_field.dart';
import 'package:fit_app/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance;
    String email = "";
    String password = "";

    Future<void> signIn(exemail, expassword) async {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: exemail,
          password: expassword
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FitnessAppHomeScreen();
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "lib/assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {email=value;},
            ),
            RoundedPasswordField(

              onChanged: (value) {password=value;},

            ),
            RoundedButton(
              text: "LOGIN",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
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
