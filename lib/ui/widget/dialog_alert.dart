import 'package:flutter/material.dart';

import '../../common/color_value.dart';

void showErrorDialog(BuildContext context, String message, String tittle_eror) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(tittle_eror,
          style: Theme
              .of(context)
              .textTheme
              .bodyText1!
              .copyWith(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message,
          style: Theme
              .of(context)
              .textTheme
              .subtitle1!
              .copyWith(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(
                color: ColorValue.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}