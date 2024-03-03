import 'package:flutter/material.dart';

import 'package:todo/ui/Themes.dart';
class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryColor
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white
            ),
          ),
        )
      ),
    );
  }
}
