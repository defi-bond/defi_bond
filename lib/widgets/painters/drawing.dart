import 'dart:math';
import 'package:flutter/material.dart';

class SPLDrawing {

  SPLDrawing();

  Offset? _vector;

  final Path path = Path();

  void _setVector(Offset point) {
    final Offset? vector = _vector;
    _vector = point;
  }

  void moveTo(double x, double y) {
    path.moveTo(x, y);
    _setVector(Offset(x, y));
  }

  void lineTo(double x, double y) {
    path.lineTo(x, y);
    _setVector(Offset(x, y));
  }

  void arcThrough(Offset point, { Offset? reference, Radius radius = Radius.zero, bool clockwise = true }) {
    path.arcToPoint(point, radius: radius, clockwise: clockwise);
    final Offset? vector = _vector;
    if (vector != null && reference != null) {
      final Offset vector0 = vector - point;
      final Offset vector1 = point - reference;
      final double angle = atan2(vector1.dy - vector0.dy, vector1.dx - vector0.dx);
    }
  }
}