import 'package:fit_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final Function subTap;
  final AnimationController animationController;
  final Animation animation;

  final Shader linearGradient;

  const TitleView(
      {Key key,
      this.linearGradient,
      this.subTap,
      this.titleTxt: "",
      this.subTxt: "",
      this.animationController,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleTxt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          foreground: Paint()..shader = linearGradient
                        ),
                      ),
                    ),
                    subTxt != "" ?  
                    InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {
                        subTap();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              subTxt,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                letterSpacing: 0.5,
                                foreground: Paint()..shader =  LinearGradient(
                                colors: <Color>[HexColor("#ff4e50"), HexColor("#f9d423")],
                                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 26,
                              child: Icon(
                                Icons.arrow_forward,
                                color: FitnessAppTheme.darkText,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) 
                    :Container()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
