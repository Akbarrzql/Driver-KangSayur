import 'package:flutter/material.dart';

import '../../common/color_value.dart';

Widget textfield(BuildContext context, String hintText, TextEditingController _namaController, TextInputType) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: ColorValue.hintColor,
        width: 0.5,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _namaController,
        keyboardType: TextInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: ColorValue.hintColor,
          ),
        ),
      ),
    ),
  );
}