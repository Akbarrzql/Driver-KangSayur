import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../common/color_value.dart';

Widget notFound(BuildContext context, String fileName, String massage){
  final textTheme = Theme.of(context).textTheme;
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Lottie.asset(fileName, width: 300, height: 300,),
          Text(
            massage,
            style: textTheme.headline6!.copyWith(
              color: ColorValue.neutralColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}