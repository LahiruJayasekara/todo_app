import 'package:flutter/material.dart';

InputDecoration textInputDecorationLoginForms = InputDecoration(
  fillColor: Colors.orange[50],
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.orange[200], width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.orange[500], width: 2.0),
  ),
);

InputDecoration textInputDecorationProfile = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.orange[500], width: 2.0),
  ),
);