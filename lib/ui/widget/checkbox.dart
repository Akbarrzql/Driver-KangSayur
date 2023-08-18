import 'package:flutter/material.dart';

class ModalCheckbox extends StatefulWidget {
  ModalCheckbox({Key? key, required this.isCheckbox, required this.name}) : super(key: key);
  bool isCheckbox;
  final String name;

  @override
  State<ModalCheckbox> createState() => _ModalCheckboxState();
}

class _ModalCheckboxState extends State<ModalCheckbox> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isCheckbox = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isCheckbox,
          onChanged: (value) {
            setState(() {
              print(value);
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


