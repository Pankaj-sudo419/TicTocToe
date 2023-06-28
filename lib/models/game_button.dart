import 'package:flutter/material.dart';

class Game_Button {
  final dynamic id;
  String text;
  Color bg;
  bool enabled;

  Game_Button({
    required this.id,
    this.text = '',
    this.bg = Colors.grey,
    this.enabled = true,
  });
}
