import 'package:flutter/material.dart';

// This File contains widgets that are being used throughout the app
// and are very similar to each other, therefore they are being standardized

// TextFormField being used throughout the app
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key, required this.textEditingController, required this.label})
      : super(key: key);

  final TextEditingController textEditingController;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }
}

// vertical Padding between elements
Padding vertPaddingbetweenElements() {
  return Padding(padding: const EdgeInsets.only(top: 20.0));
}
