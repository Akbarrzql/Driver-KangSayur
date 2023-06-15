import 'package:flutter/material.dart';

import '../../common/color_value.dart';

//if else in parameter widget

Widget main_button(String textButton, BuildContext context,{VoidCallback? onPressed} ){
  return Container(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: ColorValue.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        textButton,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}