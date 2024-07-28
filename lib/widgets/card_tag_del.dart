import 'package:flutter/material.dart';

class CardTagsDel extends StatelessWidget {
  final String title;
  final BoxDecoration decoration;

  CardTagsDel({
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
          height: 18,
          decoration: decoration,
          child: Center(
            child: Row(
              children: [
                Text(
                  '${title.split(':')[0]}:',
                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                  ),

                Text(
                  title.split(':')[1].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(decoration: TextDecoration.lineThrough
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
