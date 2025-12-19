import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/screens/auth/sign_in.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/utils/validations.dart';
import 'package:phluowise/widgets/button.dart';
import 'package:phluowise/widgets/input_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  //MARK: Creating an account
  void createAccount() {
    if (formKey.currentState!.validate()) {
      try {} catch (e) {}
    }
  }

  @override
  void dispose() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    phoneController.clear();
    passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: context.screenWidth * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset(AppImages.back),
                  ),

                  Center(
                    child: SizedBox(
                      width: context.screenWidth * .85,
                      child: Column(
                        children: [
                          Image.asset(AppImages.logo, width: 194),

                          SizedBox(height: 25),

                          Text(
                            'Find, Order With\nEase',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 19),

                          Text(
                            'Let’s Create An Account To Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          SizedBox(height: 35),

                          Form(
                            key: formKey,
                            child: Column(
                              spacing: 12,
                              children: [
                                InputField(
                                  controller: fullNameController,
                                  keyboardType: TextInputType.name,
                                  hintText: 'Full Name',
                                  prefixIcon: AppImages.profile,
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
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  hintText: 'Phone Number',
                                  prefixIcon: AppImages.calladd,
                                  validator: Validations.phoneValidator,
                                ),

                                InputField(
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: 'Password',
                                  prefixIcon: AppImages.key,
                                  suffixIcon: AppImages.eyeIcon,
                                  validator: Validations.passwordValidator,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 12,
                            children: [
                              Text(
                                'Register as:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                spacing: 12,
                                children: [
                                  Expanded(
                                    child: Button(
                                      buttonText: 'An Individual',
                                      type: 'secondary',
                                      borderRadius: 8,
                                      color: HexColor('#99FFFFFF'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Button(
                                      buttonText: 'A Business',
                                      type: 'secondary',
                                      borderRadius: 8,
                                      color: HexColor('#99FFFFFF'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 30),

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
                                  onPressed: createAccount,
                                ),
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),

                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        pushScreen(context, screen: SignIn());
                                      },
                                      child: Text(
                                        'Log In',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          decoration: TextDecoration.underline,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          decorationColor: AppColors.primary,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
