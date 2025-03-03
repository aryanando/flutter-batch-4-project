import 'package:flutter/material.dart';

extension TapExtension on Widget {
  Widget onTap(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}
