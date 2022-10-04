import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;

  ResponsiveButton({Key? key,
  this.isResponsive = false,
  this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey,
      ),
      child: Row(
        children: [
          Image.asset("lib/asset/images_welcome/button-one.png", fit: BoxFit.cover,),
        ],
      ),
    );
  }
}
