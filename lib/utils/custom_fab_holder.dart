import 'package:flutter/material.dart';

class CustomFabholder extends StatelessWidget {
  final double radius;
  final Widget icon;
  final Color backgroundColor;
  final Function () onTap;
  const CustomFabholder({super.key, required this.radius, required this.icon, required this.backgroundColor, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: icon,
      ),
    );
  }



}
