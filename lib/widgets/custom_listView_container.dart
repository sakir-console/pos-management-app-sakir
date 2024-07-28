import 'package:flutter/material.dart';

class ListViewContainer extends StatelessWidget {
  final Widget child;
  ListViewContainer({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0),
      margin: EdgeInsets.only(top:15.0,bottom: 1,left: 15,right: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey[300]!,
            spreadRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: child,
    );
  }
}