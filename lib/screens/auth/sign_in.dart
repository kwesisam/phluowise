import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/controllers/appwrite_controller.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/screens/auth/sign_up.dart';
import 'package:phluowise/services/wrapper.dart';
import 'package:phluowise/tabs.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/utils/validations.dart';
import 'package:phluowise/widgets/button.dart';
import 'package:phluowise/widgets/input_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String formError = '';

  bool isLoading = false;

  void signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        formError = '';
      });

      try {
        final res = await AppwriteAuthProvider().login(
          email: emailController.text,
          password: passwordController.text,
        );

        if (res['status'] == true) {
          showSignInSucces();
        } else {
          setState(() {
            formError = res['message'];
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          formError = 'Something went wrong while signing in, try again.';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showSignInSucces() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 10,
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Spacer(),
          
              Container(
                height: context.screenHeight * .43,
                width: context.screenWidth * 0.85,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: HexColor('#40444B'),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.check),
          
                        SizedBox(height: 24),
          
                        Text(
                          'Success !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
          
                        SizedBox(height: 11),
          
                        Text(
                          'You have Login Successfully',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
          
                        SizedBox(height: 25),
          
                        SizedBox(
                          width: 200,
                          child: Button(
                            buttonText: 'Continue',
                            borderRadius: 20,
                            onPressed: () {
                              Navigator.of(context).pop();
                              pushScreen(context, screen: Tabs());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          
              Spacer(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    formError = '';
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
                            'Hello There',
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
                            'Welcome Back\nPlease Sign In!',
                            textAlign: TextAlign.center,
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
                              spacing: 15,
                              children: [
                                InputField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: 'Email Address',
                                  prefixIcon: AppImages.smsnotification,
                                  validator: Validations.emailValidator,
                                ),

                                InputField(
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: 'Password',
                                  prefixIcon: AppImages.key,
                                  suffixIcon: AppImages.eyeIcon,
                                  validator: Validations.passwordValidator,
                                ),

                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Text(
                                        'Forget Your Password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,

                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Button(
                                  buttonText: isLoading
                                      ? 'Signing in..'
                                      : 'Sign In',
                                  borderRadius: 16,
                                  height: 56,
                                  onPressed: isLoading
                                      ? () {
                                          print('3333');
                                        }
                                      : signIn,
                                ),
                              ),

                              if (formError.isNotEmpty)
                                Center(
                                  child: Text(
                                    formError,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: HexColor('#CCE46363'),
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Expanded(child: Divider(color: Colors.white)),
                                  Text(
                                    'Or, Sign In With',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.white)),
                                ],
                              ),

                              SizedBox(
                                width: double.infinity,
                                child: Button(
                                  buttonText: 'Sign In With Google',
                                  type: 'secondary',
                                  icon: AppImages.google,
                                  color: Colors.white,
                                  borderRadius: 16,
                                  height: 56,
                                  onPressed: () {},
                                ),
                              ),

                              SizedBox(height: 34),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don’t Have An Account? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),

                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        pushScreen(context, screen: SignUp());
                                      },
                                      child: Text(
                                        'Sign Up',
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
