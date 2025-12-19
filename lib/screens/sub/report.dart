import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';
import 'package:phluowise/widgets/input_field.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
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
          'Report',
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      'Upload Images Or Videos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),

                    SvgPicture.asset(AppImages.infofill),

                    Spacer(),

                    Button(
                      buttonText: 'Delete',
                      height: 35,
                      borderRadius: 8,
                      fontSize: 16,
                    ),
                  ],
                ),

                SizedBox(height: 12),

                InputField(
                  controller: TextEditingController(),
                  maxLines: 100,
                  keyboardType: TextInputType.multiline,
                  hintText:
                      'Let’s us know your Problems; we are willing and Glad to hear from You!',
                ),

                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  10.0),
                  child: Button(
                    buttonText: 'Submit Report',
                    fontSize: 16,
                    height: 56,
                    borderRadius: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
