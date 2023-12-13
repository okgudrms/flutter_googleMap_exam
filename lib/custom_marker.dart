import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({super.key, required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 50,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(5),
            color: Colors.black,
            child: Text(
              "\$$price",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
