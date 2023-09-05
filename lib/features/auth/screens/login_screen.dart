import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/features/auth/screens/signup_screen.dart';
import 'package:instagram_clone/responsive/app_dimensions.dart';
import 'package:instagram_clone/utils/app_layout.dart';
import 'package:instagram_clone/utils/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/widgets/custom_text_button.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../../../responsive/app_responsive.dart';
import '../../../responsive/layout/mobile_screen_layout.dart';
import '../../../responsive/layout/web_screen_layout.dart';
import '../../../utils/app_constant.dart';
import '../../../widgets/custom_button.dart';
import '../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthServices authServices = AuthServices();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passwordController.dispose();
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await authServices.signInUser(
      email: _emailcontroller.text,
      password: _passwordController.text,
    );
    if (res == 'success') {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, ResponsiveLayout.routeName);
    } else {
      Constant.instance.showSnackbar(context, res);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > Dimensions.webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3,
                )
              : EdgeInsets.symmetric(
                  horizontal: AppLayout.getWidth(32),
                ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: Styles.primaryColor,
                height: AppLayout.getHeight(60),
              ),
              Gap(AppLayout.getHeight(64)),
              TextFieldInput(
                controller: _emailcontroller,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              Gap(AppLayout.getHeight(24)),
              TextFieldInput(
                controller: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              Gap(AppLayout.getHeight(24)),
              CustomButton(
                text: 'Log in',
                onPressed: () => signInUser(),
                isLoading: _isLoading,
              ),
              Gap(AppLayout.getHeight(12)),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text('Don\'t have an account?'),
                    padding: EdgeInsets.symmetric(
                      vertical: AppLayout.getWidth(AppLayout.getHeight(8)),
                    ),
                  ),
                  Gap(AppLayout.getWidth(4)),
                  CustomTextButton(
                      text: 'Sign up',
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
