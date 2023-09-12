import 'package:flacon_shop/utils/colors.dart';
import 'package:flutter/material.dart';

class CenterDots extends StatelessWidget {
  const CenterDots({Key? key, required this.activeDotIndex}) : super(key: key);

  final int activeDotIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (activeDotIndex == index) {
          return activeDot();
        }
        return inActiveDot();
      }),
    );
  }

  Widget activeDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
    );
  }

  Widget inActiveDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white.withOpacity(0.32),
      ),
    );
  }
}
