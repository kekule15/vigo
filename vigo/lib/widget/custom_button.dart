
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget? title;
  final Function? onclick;
  final Color? color;
  final bool? borderColor;

  const CustomButton(
      {Key? key,required this.title,required this.onclick,required this.color,required this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onclick!();
      },
      child: Container(
        height: 48,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
              color: borderColor! ? Colors.white : Colors.red),
          borderRadius: BorderRadius.circular(10),
          color: color!,
        ),
        child: Center(
          child: title!,
        ),
      ),
    );
  }
}
