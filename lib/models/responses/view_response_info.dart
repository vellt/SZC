import 'package:flutter/material.dart';

class ViewResponseInfo {
  bool status;
  String title;
  String message;
  Color foregroundColor;
  Color backgroundColor;
  ViewResponseInfo({
    required this.status,
    required this.title,
    required this.message,
    required this.foregroundColor,
    required this.backgroundColor,
  });
}
