import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/utils/validations.dart';
import 'package:phluowise/widgets/button.dart';
import 'package:phluowise/widgets/input_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();

  @override
  void dispose() {
    fullNameController.clear();
    idController.clear();
    emailController.clear();
    phone1Controller.clear();
    phone2Controller.clear();
    super.dispose();
  }

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
              child: Column(spacing: 40, children: [editProfile(), content()]),
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
        Stack(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: HexColor('#292B2F'),
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: SvgPicture.asset(AppImages.profile),
              ),
            ),

            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 35,
                  height: 35,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HexColor('#40444B'),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset(AppImages.edit),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget content() {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20,
        children: [
          InputField(
            controller: fullNameController,
            keyboardType: TextInputType.name,
            hintText: 'Full Name',
            prefixIcon: AppImages.profile,
            validator: Validations.nameValidator,
          ),

          InputField(
            controller: idController,
            keyboardType: TextInputType.name,
            hintText: 'User ID Number',
            prefixIcon: AppImages.personalcard,
            validator: Validations.nameValidator,
          ),

          InputField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Email Address',
            prefixIcon: AppImages.smsnotification,
            validator: Validations.emailValidator,
          ),

          InputField(
            controller: phone1Controller,
            keyboardType: TextInputType.phone,
            hintText: 'Phone Number 1',
            prefixIcon: AppImages.calladd,
            validator: Validations.phoneValidator,
          ),

          InputField(
            controller: phone2Controller,
            keyboardType: TextInputType.phone,
            hintText: 'Phone Number 2',
            prefixIcon: AppImages.calladd,
            validator: Validations.phoneValidator,
          ),

          SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: Button(
              buttonText: 'Update',
              borderRadius: 16,
              height: 56,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
