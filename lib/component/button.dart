import 'package:flutter/material.dart';
class RoundeButton extends StatelessWidget{
  RoundeButton({this.title, this.color, this.onPressed});
  final Color? color;
  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Material(
          elevation: 5.0,
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          child: MaterialButton(
            onPressed: onPressed!,
            minWidth: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.15,
            child: Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
    );
  }
}