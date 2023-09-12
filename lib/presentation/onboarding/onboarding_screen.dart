// ignore_for_file: library_private_types_in_public_api

import 'package:flacon_shop/presentation/onboarding/widget/center_dots.dart';
import 'package:flacon_shop/presentation/tabbox/tabbox.dart';
import 'package:flacon_shop/utils/colors.dart';
import 'package:flacon_shop/utils/icons.dart';
import 'package:flacon_shop/widgets/global_button.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LowerShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  List<String> imageAssets = [
    AppImages.splash1,
    AppImages.splash2,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            allowImplicitScrolling: true,
            controller: _pageController,
            itemCount: imageAssets.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                imageAssets[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          ClipPath(
            clipper: LowerShadowClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.baseDark.withOpacity(0.9),
                    AppColors.baseDark.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                imageAssets.indexOf(imageAssets[_currentPageIndex]) == 0
                    ? AppImages.text1
                    : AppImages.text2,
                width: 300,
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: 115,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: AppColors.baseDark,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CenterDots(activeDotIndex: _currentPageIndex),
                      ZoomTapAnimation(
                        child: GlobalButton(
                          buttonText: _currentPageIndex == 0 ? '    Next':'    Continue',
                          iconData: Icons.arrow_forward_ios,
                          onPressed: () {
                            if (_currentPageIndex < imageAssets.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.ease,
                              );
                            }
                            if (_currentPageIndex == 1){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const TabBox()));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
