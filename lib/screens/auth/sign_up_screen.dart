import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_app_userside/screens/auth/login_screen.dart';
import 'package:salon_app_userside/screens/auth/widgets/auth_footer.dart';
import 'package:salon_app_userside/services/auth_services.dart';
import 'package:salon_app_userside/services/notification_services.dart';
import 'package:salon_app_userside/themes/app_colors.dart';
import 'package:salon_app_userside/utils/navigations.dart';
import 'package:salon_app_userside/widgets/buttons.dart';
import 'package:salon_app_userside/widgets/custom_text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController=TextEditingController();
  File? selectedImage;

  String? deviceToken;
  NotificationServices notificationServices=NotificationServices();

  void initState() {

    // TODO: implement initState

    notificationServices.getNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value){
      print("Device Token: $value");
      deviceToken=value;
    });
    super.initState();
  }



  getImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(
                "Book Me",
                style: TextStyle(
                  color: AppColors.btnColor,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 30),
              if (selectedImage == null)
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: AppColors.greyWhite,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: getImage,
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.primaryWhite,
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              else
                CircleAvatar(
                  radius: 55,
                  backgroundColor: AppColors.greyWhite,
                  backgroundImage: FileImage(File(selectedImage!.path)),
                ),
              const SizedBox(height: 30),
              CustomTextInput(controller: usernameController, hintText: "name"),
              const SizedBox(height: 15),
              CustomTextInput(controller: emailController, hintText: "email"),
              const SizedBox(height: 15),
              CustomTextInput(controller: phoneController, hintText: "Phone Number",
              keyboarType: TextInputType.phone,),
              const SizedBox(height: 15),
              CustomTextInput(controller: passwordController, hintText: "password"),
              const SizedBox(height: 40),
              PrimaryButton(
                title: "Sign Up",
                onPressed: () async {
                  if (selectedImage == null) {
                    EasyLoading.showError("Please Select an Image");
                  } else if (usernameController.text.isEmpty) {
                    EasyLoading.showError("username Must Be Filled");
                  } else if (emailController.text.isEmpty) {
                    EasyLoading.showError("Email Must Be Filled");
                  }  else if (phoneController.text.isEmpty) {
                    EasyLoading.showError("Phone Number Must Be Filled");
                  }else if (passwordController.text.isEmpty) {
                    EasyLoading.showError("Password Must Be Filled");
                  } else {
                    await AuthServices.signUp(
                      context: context,
                      username: usernameController.text,
                      email: emailController.text,
                      phoneNumber: phoneController.text,
                      password: passwordController.text,
                      selectedImage: selectedImage,
                      deviceToken: deviceToken,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              AuthFooter(
                onPressed: () => navigateToPage(context, const LoginScreen()),
                title: "Already have an Account ?",
                screenName: "Login",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
