import 'package:flutter/material.dart';
import 'package:tezda/theme/colour.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text, style: TextStyle(color: AppColour.black)),
    backgroundColor: AppColour.primary,
  ));
}
