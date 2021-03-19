import 'package:flutter/material.dart';
import '../fitness_app_theme.dart';

class AddWorkout extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const AddWorkout({Key key, this.animationController, this.animation})
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 14, bottom: 0),
                  child:  Container(
                    width: 60,
                    height: 60,
                    child: Icon(Icons.add, size: 20, color: Colors.white,),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FitnessAppTheme.nearlyDark,
                        border: Border.all(width: 2.0, color: FitnessAppTheme.nearlyBlue)
                        ),
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
