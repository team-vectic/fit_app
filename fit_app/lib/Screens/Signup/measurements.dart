import 'package:fit_app/constants.dart';
import 'package:fit_app/fitness_app_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_app/components/rounded_button.dart';
import 'package:fit_app/Screens/Signup/components/background.dart';
import 'package:fit_app/components/text_field_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Measurements extends StatefulWidget {

  @override
  _Measurements createState() => _Measurements();

}
class _Measurements extends State<Measurements> {

    @override
  void initState() { 
    super.initState();
    userid = FirebaseAuth.instance.currentUser.uid.toString();
  }
  

    String userid = "";

    bool _toggled = true;
    Color inactivecolor = Colors.blue;
    Color activecolor = Colors.red;
    String text = "Woman";
    String imagePath = "lib/assets/fitness_app/area3.png";
    double weight;
    double height;
    double watergoal;
    double caloriegoal;
    double gender;
    double age;

    void checkData(){
      if (_toggled == true)
          gender = 1;
      else
      {
        gender = 0;
      }
      addUserBodyData();
    }
    Future<void> addUserBodyData() {
    double bmi = weight / (height*height);
    FirebaseDatabase.instance.reference().child('users').child("$userid").child("bodydata")
      .set({
          'weight' : weight, 
          'height' : height,
          'bmi' : bmi.round(),
          'watergoal' : watergoal,
          'caloriegoal' : caloriegoal,
          'gender' : gender,
          'age' : age,
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NutritionGoal())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
    FirebaseDatabase.instance.reference().child('users').child("$userid").
      update({
          'avatar' : gender == 0 ? "https://i.ibb.co/58zbPFL/Memoji-10.png" : "https://i.ibb.co/4grqQ41/Memoji-26.png"
      })
      .catchError((error) => print("Failed to add user: $error"));
    }  

  @override
  Widget build(BuildContext context) {

    //UI

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child:
          Stack(
          children: <Widget>[
          Background(
          
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                Text(
                  "Measurements",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset(
                 '$imagePath',
                  height: size.height * 0.30,
                ),
                SwitchListTile(
                secondary: Icon(Icons.notifications, color: Colors.white,),
                title:Text('$text', style: TextStyle(color: _toggled ? activecolor : inactivecolor),),
                 // just a custom font, otherwise a regular Text widget
                value: _toggled,
                activeColor: activecolor,
                inactiveTrackColor: inactivecolor,
                onChanged: (bool value){
                  setState(() {
                    _onSwitchChanged(value);

                  });
                },
                ),
                SizedBox(height: size.height * 0.02),
                InputField(
                    hintText: "Weight (KG)",
                    icon: Icons.accessibility,
                    onChanged: (value) {weight=double.parse(value);},

                ),
                SizedBox(height: size.height * 0.02),

                InputField(
                    hintText: "Age",
                    icon: Icons.accessibility,
                    onChanged: (value) {age=double.parse(value);},

                ),
                SizedBox(height: size.height * 0.02),

                InputField(
                    hintText: "Height (M)",
                    icon: Icons.height,
                    onChanged: (value) {height=double.parse(value);},
                
                ),
                SizedBox(height: size.height * 0.02),

                InputField(
                    hintText: "WaterPerDay (L)",
                    icon: Icons.local_drink,
                    onChanged: (value) {watergoal=double.parse(value);},


                ),
                SizedBox(height: size.height * 0.02),

                InputField(
                    hintText: "CaloriesPerDay (KCAL)",
                    icon: Icons.food_bank,
                    onChanged: (value) {caloriegoal=double.parse(value);},

                    
                ),
                SizedBox(height: size.height * 0.02),

                 
                RoundedButton(
                  text: "Next ->",
                  press: () {checkData();},
                ),
                SizedBox(height: size.height * 0.02),
              ],
            )
                ),
          
          ),
          ],
      ),
      ),
    );
  }

  void _onSwitchChanged(bool value) {
//    setState(() {
    _toggled = value;
    if (text=="Male"){
      text = "Woman";
      imagePath = "lib/assets/fitness_app/area3.png";
    }
    else
   {
     text = "Male";
    imagePath = "lib/assets/fitness_app/area1.png";

   } 
//    });
  }

}

class InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const InputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
        cursorColor: Colors.purple,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryLightColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color:Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }
}


class NutritionGoal extends StatefulWidget {

  @override
  _NutritionGoal createState() => _NutritionGoal();

}
class _NutritionGoal extends State<NutritionGoal> {

    @override
  void initState() { 
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges()
    .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');

      } else {
        print('User is signed in!');
        userid = user.uid;
      }
    });
  }
  
    String userid = "";

    var proteingoal;
    var fatgoal;
    var carbsgoal;

    Future<void> addUserNutritionData() {
    
    FirebaseDatabase.instance.reference().child('users').child("$userid").child("bodydata")
      .update({
          'proteingoal' : proteingoal, 
          'fatgoal' : fatgoal,
          'carbsgoal' : carbsgoal,
      })
      .then((value) =>       
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessAppHomeScreen())
      ),          
      )
      .catchError((error) => print("Failed to add user: $error"));
    }  

  @override
  Widget build(BuildContext context) {

    //UI

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child:
          Stack(
          children: <Widget>[
          Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                Text(
                  "Body Nutrition Goal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                ),
                SizedBox(height: size.height * 0.02),
                InputField(
                    hintText: "Protein Goal (G)",
                    icon: Icons.accessibility,
                    onChanged: (value) {proteingoal=double.parse(value);},

                ),
                SizedBox(height: size.height * 0.02),      
                InputField(
                    hintText: "Carbs Goal (G)",
                    icon: Icons.accessibility,
                    onChanged: (value) {carbsgoal=double.parse(value);},

                ),
                SizedBox(height: size.height * 0.02),
                InputField(
                    hintText: "Fat Goal (G)",
                    icon: Icons.accessibility,
                    onChanged: (value) {fatgoal=double.parse(value);},

                ),
                SizedBox(height: size.height * 0.02),       
                RoundedButton(
                  text: "Confirm",
                  press: () {addUserNutritionData();},
                ),
                SizedBox(height: size.height * 0.02),
              ],
            )
          ),
          ),
          ],
      ),
      ),
    );
  }

}

