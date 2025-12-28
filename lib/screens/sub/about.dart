import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

List<Map<String, dynamic>> data = [
  {
    'name': 'Newletter',
    'icon': AppImages.securitysafe,
    'link': 'https://www.phluow.framer.website/',
  },
  {
    'name': 'Terms and Conditions',
    'icon': AppImages.globalrefresh,
    'link':
        'https://docs.google.com/document/d/1qlcHItjmYevCtRI8eLOnBb-EA5NM1dB__OCGo_3YGfY/edit?tab=t.0',
  },
  {
    'name': 'Privacy Policy',
    'icon': AppImages.book,
    'link':
        'https://docs.google.com/document/d/1Kje7RL3gKB1lHEyXtC7UDQ0Q3xRGezW1klo68Bm5K0I/edit?usp=sharing',
  },
  {
    'name': 'Disclaimer',
    'icon': AppImages.disclaimer,
    'link':
        'https://docs.google.com/document/d/1EdZAyHTvLLe9XsPXw72b6rcDbV-CmXXWECQP6qUZRYI/edit?tab=t.0',
  },
];

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

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
            fontSize: 20,
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
                SizedBox(height: 56),

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
                  onTap: () {
                    _launchInBrowser(Uri.parse(ele['link']));
                  },
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
