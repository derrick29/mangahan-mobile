import 'package:flutter/material.dart';
import 'package:mangahan/constants/constants.dart';

class InfoBtn extends StatelessWidget {
  final IconData icon;
  final String btnText;

  const InfoBtn({Key? key, required this.icon, required this.btnText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 35, color: Constants.lightBlue,),
        Text(
          btnText,
          style: TextStyle(
            color: Colors.white
          ),
        )
      ],
    );
  }
}
