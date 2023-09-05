import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/auth/screens/login_screen.dart';
import 'package:instagram_clone/features/auth/services/auth_services.dart';

import '../../../responsive/app_responsive.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/app_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AuthServices authServices = AuthServices();
  Uint8List? _image;
  bool isLoading = false;

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await authServices.signUpUser(
      email: _emailcontroller.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    if (res == 'success') {
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, ResponsiveLayout.routeName);
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Constant.instance.showSnackbar(context, res);
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  void selectImage() async {
    Uint8List image = await Constant.instance.pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
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
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              Image.asset('./assets/images/default_profile.png')
                                  .image,
                        ),
                  Positioned(
                    bottom: AppLayout.getHeight(-10),
                    left: AppLayout.getWidth(80),
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              Gap(AppLayout.getHeight(24)),
              TextFieldInput(
                controller: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
              ),
              Gap(AppLayout.getHeight(24)),
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
              TextFieldInput(
                controller: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
              ),
              Gap(AppLayout.getHeight(24)),
              CustomButton(
                text: 'Sign up',
                onPressed: () => signUpUser(),
                isLoading: isLoading,
              ),
              Gap(AppLayout.getHeight(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Already have an account?'),
                    padding: EdgeInsets.symmetric(
                      vertical: AppLayout.getHeight(
                        8,
                      ),
                    ),
                  ),
                  Gap(AppLayout.getWidth(4)),
                  CustomTextButton(
                    text: 'Sign in',
                    onPressed: () => navigateToLogin(),
                  )
                ],
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
