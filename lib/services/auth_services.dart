import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:salon_app_userside/services/notification_services.dart';
import 'package:salon_app_userside/services/storage_services.dart';
import 'package:salon_app_userside/services/token_Services.dart';

import '../models/user_model.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../utils/navigations.dart';
import 'notification_services.dart';

class AuthServices {
  static signUp({BuildContext? context,
    String? email,
    String? password,
    String? username,
    String? phoneNumber,
    File? selectedImage,
    String? deviceToken}) async {
    try {
      EasyLoading.show(status: "Please Wait");

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);

      String url = await StorageServices().uploadImageToDB(selectedImage);

      UserModel userModel = UserModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        email: email,
        username: username,
        phoneNumber: phoneNumber,
        image: url,
        isAdmin: false,
        deviceToken:deviceToken
      );

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(userModel.toMap());
      Navigator.pushAndRemoveUntil(context!, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static signIn({BuildContext? context, String? email, String? password,String? deviceToken}) async {
    try {
      EasyLoading.show(status: "Please Wait");
      UserCredential result=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
      if(result.user!=null){
        bool isUser=false;
        var authenticate=await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).get();
        if(authenticate.exists){
          isUser=authenticate["isAdmin"];
          if(isUser==true){
            ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text("User Account not exist")));
          }else{
            if(deviceToken!=null) {
              await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).update({'deviceToken':deviceToken});
              await TokenServices().uploadToken(deviceToken: deviceToken);
            }else{
              await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).update({'deviceToken':'deviceToken'});
              await TokenServices().uploadToken(deviceToken: 'device token');
            }
            Navigator.pushAndRemoveUntil(context!, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);

          }

          EasyLoading.dismiss();
        }else{
          ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text("User Account not exist")));

          EasyLoading.dismiss();
        }

      }

    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static logOut({BuildContext? context,String? userId}) async {
    try {
      EasyLoading.show(status: "Please wait");
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'deviceToken':'logged out'});
      await FirebaseAuth.instance.signOut();
      EasyLoading.dismiss();
      navigateToPage(context!, const LoginScreen());
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }
}
