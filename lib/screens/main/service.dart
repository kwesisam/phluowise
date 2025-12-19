import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: context.screenWidth * .95,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Expanded(child: search()),
                    Container(
                      width: 42,
                      height: 42,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: HexColor('#292B2F'),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset(AppImages.document),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Center(
            //   child: SizedBox(
            //     width: context.screenWidth * .95,
            //     child: filter(),
            //   ),
            // ),
            // SizedBox(height: 15),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: context.screenWidth * .85,
                  child: SingleChildScrollView(
                    child: Column(spacing: 31, children: [card(), card()]),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }



  Widget search() {
    return TextField(
      decoration: InputDecoration(
        fillColor: HexColor('#40444B'),
        filled: true,
        hintText: 'Search',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: HexColor('#40444B')),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: HexColor('#40444B')),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 5),
          child: SvgPicture.asset(AppImages.search, width: 23, height: 23),
        ),
        suffixIconConstraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
      ),
    );
  }

  Widget content() {
    return Container();
  }
  Widget card() {
    return Container(
      height: 540,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HexColor('#40444B'),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 135,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.image2),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 55,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name of Company',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        text: 'location',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: ' 10min away',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: HexColor('#2C9043'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 9,
                      children: [
                        Text(
                          'Select a product to Schedule order',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#99FFFFFF'),
                          ),
                        ),
                        Row(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 83,
                                  height: 83,
                                  decoration: BoxDecoration(
                                    color: HexColor('#292B2F'),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                SizedBox(height: 11),

                                Text(
                                  'GHS 20.00',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 13),

                                Row(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppImages.starhalf),
                                    Text(
                                      '4 star rating',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                Container(
                                  width: 83,
                                  height: 83,
                                  decoration: BoxDecoration(
                                    color: HexColor('#292B2F'),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(height: 11),
                                Text(
                                  'GHS 20.00',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 13),

                                Row(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppImages.star),
                                    Text(
                                      '4 star rating',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                Container(
                                  width: 83,
                                  height: 83,
                                  decoration: BoxDecoration(
                                    color: HexColor('#292B2F'),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(height: 11),
                                Text(
                                  'GHS 20.00',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 13),

                                Row(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppImages.star),
                                    Text(
                                      '4 star rating',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 41),

                    Button(
                      buttonText: 'Schedule Order',
                      fontSize: 18,
                      borderRadius: 20,
                      height: 46,
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            left: 120,
            top: 90,
            child: Container(
              width: 100,
              height: 97,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: HexColor('#292B2F'),
                border: Border.all(width: 6, color: HexColor('#40444B'))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
