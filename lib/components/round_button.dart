import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const RoundButton({required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: Colors.blueGrey,
        height: 50,
        minWidth: double.infinity,
        onPressed: onPress,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
