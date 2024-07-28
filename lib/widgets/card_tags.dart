import 'package:flutter/material.dart';
import 'package:pos_by_sakir/values/values.dart';


class CardTags extends StatelessWidget {
  final String title;
  final BoxDecoration decoration;

  const CardTags({
    required this.title,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(
        opacity: 0.8,
        child: Container(
          padding: EdgeInsets.only(left: 5,right: 5),
          //width: 70,
          height: 20,
          decoration: decoration,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Styles.customNormalTextStyle(
                fontSize: 9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
