import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/utils/hexColor.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

List<Map<String, dynamic>> data = [
  {'name': 'Newletter', 'icon': AppImages.securitysafe},
  {'name': 'Terms and Conditions', 'icon': AppImages.globalrefresh},
  {'name': 'Privacy Policy', 'icon': AppImages.book},
  {'name': 'Disclaimer', 'icon': AppImages.disclaimer},
];

class _AboutState extends State<About> {
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
        title: Text(
          'About',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
    
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: context.screenWidth * .9,
            child: Column(
              children: [
                SizedBox(height: 24),

                content(),

                Spacer(),

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
                    leading: SvgPicture.asset(AppImages.directboxsend),
                    title: Text(
                      'Share Phluow',
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

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
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
                    bottom: ele['name'] == 'Disclaimer'
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.shade100, width: .1),
                  ),
                ),
                child: ListTile(
                  leading: SvgPicture.asset(ele['icon']),
                  title: Text(
                    ele['name'],
                    style: TextStyle(
                      decorationColor: HexColor('#FFFFFF'),
                      decoration: TextDecoration.underline,
                      color: HexColor('#FFFFFF'),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: SvgPicture.asset(AppImages.arrowright2),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
