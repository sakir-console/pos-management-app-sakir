import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {

  const RatingBar({super.key,  required this.rating}) ;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rating.floor(), (index) {
        return Icon(
          Icons.star,
          color: Colors.white,
          size: 16,
        );
      }),
    );
  }
}
