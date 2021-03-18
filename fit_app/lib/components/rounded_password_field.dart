import 'package:flutter/material.dart';
import 'package:fit_app/components/text_field_container.dart';
import 'package:fit_app/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  bool isHidden;

  final ValueChanged<String> onChanged;
  RoundedPasswordField({
    this.isHidden = true,
    this.hintText, 
    this.icon,
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        style: TextStyle(color: Colors.white),
        obscureText: isHidden,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password 🔑",
          hintStyle: TextStyle(color:Colors.white),
          fillColor: Colors.white,

          icon: Icon(
            Icons.lock,
            color: kPrimaryLightColor,
          ),
          suffixIcon: InkWell(
            child:Icon(
            isHidden ? 
            Icons.visibility_off
            : Icons.visibility, 
            color: kPrimaryLightColor,
          ),
          onTap: () {
            isHidden = !isHidden;
            (context as Element).markNeedsBuild();

          },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
