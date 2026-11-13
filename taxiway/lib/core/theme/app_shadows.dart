import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0A101114), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0D101114), blurRadius: 16, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(color: Color(0x14101114), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x1F101114), blurRadius: 32, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> selected = [
    BoxShadow(color: Color(0x14101114), blurRadius: 14, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> sheet = [
    BoxShadow(color: Color(0x1A101114), blurRadius: 24, offset: Offset(0, -6)),
  ];
}
