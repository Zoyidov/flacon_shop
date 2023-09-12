import 'package:flutter/material.dart';

class TotalPrice extends StatelessWidget {
  final String totalPrice;

  const TotalPrice({
    Key? key, required this.totalPrice,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
        color: Colors.white,
      ),
      child: Text(totalPrice),
    );
  }
}
