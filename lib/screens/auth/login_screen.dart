import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:salon_app_userside/screens/auth/sign_up_screen.dart';
import 'package:salon_app_userside/screens/auth/widgets/auth_footer.dart';
import 'package:salon_app_userside/services/auth_services.dart';
import 'package:salon_app_userside/utils/navigations.dart';

import '../../services/notification_services.dart';
import '../../themes/app_colors.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Book Me",
              style: TextStyle(
                color: AppColors.btnColor,
                fontSize: 42,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 30),
            CustomTextInput(controller: emailController, hintText: "email"),
            const SizedBox(height: 15),
            CustomTextInput(controller: passwordController, hintText: "password"),
            const SizedBox(height: 40),
            PrimaryButton(
                title: "Login",
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    EasyLoading.showError("Email Must Be Filled");
                  } else if (passwordController.text.isEmpty) {
                    EasyLoading.showError("Password Must Be Filled");
                  } else {
                    await AuthServices.signIn(
                      context: context,
                      email: emailController.text,
                      password: passwordController.text,
                      deviceToken: deviceToken
                    );
                  }
                }),
            const SizedBox(height: 20),
            AuthFooter(
              onPressed: () => navigateToPage(context, const SignUpScreen()),
              title: "Don't have an Account?",
              screenName: " Register",
            ),
          ],
        ),
      ),
    );
  }
}
