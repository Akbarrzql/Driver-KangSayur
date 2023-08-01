import 'package:flutter/material.dart';

class ModalCheckbox extends StatefulWidget {
  ModalCheckbox({Key? key, required this.isCheckbox, required this.name}) : super(key: key);
  bool isCheckbox = false;
  final String name;

  @override
  State<ModalCheckbox> createState() => _ModalCheckboxState();
}

class _ModalCheckboxState extends State<ModalCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isCheckbox,
          onChanged: (value) {
            setState(() {
              widget.isCheckbox = value!;
            });
          },
        ),
        Text(
          widget.name,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

