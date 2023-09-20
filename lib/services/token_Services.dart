import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class TokenServices {

  uploadToken({
    required String deviceToken
  }) async {

    try {
      EasyLoading.show(status: "Please Wait");

      var deviceIdStatus=await FirebaseFirestore.instance.collection('device tokens').where('device token',isEqualTo: deviceToken).get();
      if(deviceIdStatus.docs.isEmpty) {
        await FirebaseFirestore.instance.collection("device tokens").add({
        'device token':deviceToken
      });
      }

      EasyLoading.dismiss();
      // navigateToPage(context!, const HomeScreen());
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }
}
