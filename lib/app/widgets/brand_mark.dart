import 'package:flutter/material.dart';

import '../theme.dart';

/// Small steering-wheel mark shown at the top of the study/exam screens.
/// Kept as an abstract icon rather than the full logo — the logo's fine
/// print ("Driving School") won't read at this size.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.brandPink, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.directions_car_filled_rounded,
        size: size * 0.55,
        color: Colors.white,
      ),
    );
  }
}
