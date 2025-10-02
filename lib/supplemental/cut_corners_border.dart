// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import 'package:flutter/material.dart';

class CutCornersBorder extends OutlineInputBorder {
  const CutCornersBorder({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(2.0)),
    this.cut = 7.0,
  }) : super(borderSide: borderSide, borderRadius: borderRadius);

  @override
  CutCornersBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    double? cut,
  }) {
    return CutCornersBorder(
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      cut: cut ?? this.cut,
    );
  }

  final double cut;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CutCornersBorder) {
      final CutCornersBorder outline = a;
      return CutCornersBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        cut: cut * t,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CutCornersBorder) {
      final CutCornersBorder outline = b;
      return CutCornersBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        cut: cut * t,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _notchedCornerPath(rect.deflate(borderSide.width), cut);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _notchedCornerPath(rect, cut);
  }

  static Path _notchedCornerPath(Rect rect, double cut) {
    return Path()
      ..moveTo(rect.left, rect.top + cut)
      ..lineTo(rect.left + cut, rect.top)
      ..lineTo(rect.right - cut, rect.top)
      ..lineTo(rect.right, rect.top + cut)
      ..lineTo(rect.right, rect.bottom - cut)
      ..lineTo(rect.right - cut, rect.bottom)
      ..lineTo(rect.left + cut, rect.bottom)
      ..lineTo(rect.left, rect.bottom - cut)
      ..close();
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    assert(gapExtent != null);
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);

    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);
    if (gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
      canvas.drawPath(_notchedCornerPath(center.outerRect, cut), paint);
    } else {
      final double extent =
          lerpDouble(0.0, gapExtent + gapPercentage * cut, gapPercentage)!;
      switch (textDirection ?? TextDirection.ltr) {
        case TextDirection.rtl:
          {
            final Path path = _notchedCornerPath(center.outerRect, cut);
            path.addRect(Rect.fromLTWH(
                center.left + cut - extent, center.top, extent, cut));
            canvas.drawPath(path, paint);
            break;
          }
        case TextDirection.ltr:
          {
            final Path path = _notchedCornerPath(center.outerRect, cut);
            path.addRect(Rect.fromLTWH(
                center.left + cut, center.top, extent, cut));
            canvas.drawPath(path, paint);
            break;
          }
      }
    }
  }
}

double? lerpDouble(double? a, double? b, double t) {
  if (a == b || (a?.isNaN == true) && (b?.isNaN == true)) return a;
  a ??= 0.0;
  b ??= 0.0;
  return a * (1.0 - t) + b * t;
}