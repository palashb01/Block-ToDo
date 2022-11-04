import 'package:flutter/material.dart';
import 'package:over_engineered/constants.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: kWhite, fontFamily: 'SSPRegular'),
      ),
      backgroundColor: kPrimary,
      padding: EdgeInsets.all(20),
    ),
  );
}
