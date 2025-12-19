import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/controllers/appwrite_controller.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/screens/auth/sign_in.dart';
import 'package:phluowise/screens/sub/about.dart';
import 'package:phluowise/screens/sub/edit_profile.dart';
import 'package:phluowise/screens/sub/report.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Map<String, dynamic>> data = [
    {'name': 'Payments', 'icon': AppImages.moneychange, 'onpress': 'payment'},
    {'name': 'History', 'icon': AppImages.globalrefresh, 'onpress': 'history'},
    {
      'name': 'About',
      'icon': 'assets/icons/infocircle.svg',
      'onpress': 'about',
    },
    {'name': 'Settings', 'icon': AppImages.settings},
    {'name': 'Report', 'icon': AppImages.bug, 'onpress': 'report'},
    {'name': 'Theme', 'icon': AppImages.moon},
    {'name': 'Delete Account', 'icon': AppImages.profiledelete},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#202225'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(AppImages.back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: context.screenWidth * .9,
              child: Column(
                children: [
                  editProfile(),

                  SizedBox(height: 24),

                  content(),

                  SizedBox(height: 17),

                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: HexColor('#292B2F'),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                          color: HexColor('#40000000'),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: SvgPicture.asset(AppImages.logoutcurve),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: HexColor('#FFFFFF'),
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: SvgPicture.asset(AppImages.arrowright2),
                    ),
                  ),

                  SizedBox(height: 40),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        'Phluowise',
                        style: TextStyle(
                          color: HexColor('#808080'),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'version 1.0.0',
                        style: TextStyle(
                          color: HexColor('#F5F5F5F5'),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget editProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: HexColor('#292B2F'),
          ),
        ),

        Text(
          'Eben Oppong Christian',
          style: TextStyle(
            color: HexColor('#FFFFFF'),
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),

        IntrinsicWidth(
          child: SizedBox(
            height: 30,

            child: Button(
              buttonText: 'Edit Profile',
              borderRadius: 100,
              fontSize: 14,
              onPressed: () {
                pushScreen(context, screen: EditProfile());
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget content() {
    return Container(
      decoration: BoxDecoration(
        color: HexColor('#292B2F'),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
            color: HexColor('#40000000'),
          ),
        ],
      ),
      child: Column(
        children: data
            .map(
              (ele) => Container(
                height: 65,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: ele['name'] == 'Delete Account'
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.shade100, width: .1),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    if (ele['onpress'] == 'about') {
                      pushScreen(context, screen: About());
                    }
                    
                    if (ele['onpress'] == 'report') {
                      print('222');
                      pushScreen(context, screen: Report());
                    }
                  },
                  leading: SvgPicture.asset(ele['icon']),
                  title: Text(
                    ele['name'],
                    style: TextStyle(
                      color: HexColor('#FFFFFF'),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: ele['name'] == 'Theme'
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor('#1AFFFFFF'),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                                color: HexColor('#40000000'),
                              ),
                            ],
                          ),
                          child: Text(
                            'Dark',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : SvgPicture.asset(AppImages.arrowright2),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
