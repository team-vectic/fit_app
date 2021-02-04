import 'package:flutter/material.dart';
import 'package:fit_app/components/text_field_container.dart';
import 'package:fit_app/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        style: TextStyle(color: Colors.white),
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(color:Colors.white),
          fillColor: Colors.white,

          icon: Icon(
            Icons.lock,
            color: kPrimaryLightColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryLightColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
