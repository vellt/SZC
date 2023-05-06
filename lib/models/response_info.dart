import 'package:flutter/material.dart';

class ResponseInfo {
  bool status;
  String title;
  String message;
  Color foregroundColor;
  Color backgroundColor;
  ResponseInfo({
    required this.status,
    required this.title,
    required this.message,
    required this.foregroundColor,
    required this.backgroundColor,
  });
}
