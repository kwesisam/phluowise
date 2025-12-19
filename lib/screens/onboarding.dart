import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/screens/auth/sign_in.dart';
import 'package:phluowise/screens/auth/sign_up.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  List<String> items = [AppImages.ob1, AppImages.ob2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: context.screenWidth * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),

                CarouselSlider(
                  carouselController: _controller,

                  options: CarouselOptions(
                    height: context.screenHeight * .45,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,

                    // autoPlay: false,
                    //scrollPhysics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),

                  items: items.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset(i),
                        );
                      },
                    );
                  }).toList(),
                ),
            
                buildSlideContent(_current),

                SizedBox(height: 60),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller?.animateToPage(entry.key),
                      child: Container(
                        width: _current == entry.key ? 22 : 6.0,
                        height: 4,
                        margin: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: _current == entry.key
                              ? AppColors.primary
                              : Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,

                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        buttonText: 'Create An Account',
                        borderRadius: 16,
                        height: 56,
                        onPressed: () {

                            pushScreen(context, screen: SignUp());
                        
                        },
                      ),
                    ),

                    Center(
                      child: InkWell(
                        onTap: () {
                          pushScreen(context, screen: SignIn());
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'By continuing you ',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),

                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Agree To Our Terms Of Service & Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.solid,
                                decorationColor: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSlideContent(int index) {
    switch (index) {
      case 0:
        return first();
      case 1:
        return second();
      default:
        return SizedBox.shrink();
    }
  }

  Widget first() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          'Order with ease',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.6,
          ),
        ),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                'Find, Order, And Track The Delivery Of\nWater From Reliable And Certified\nSuppliers.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget second() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Text(
          'We Made It Simple',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.6,
          ),
        ),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                'Phluowise For Customers Is The Best\nWay To Meet Your Water Needs.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
