import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? username;
  String? email;
  String? image;
  bool? isAdmin;
  String? deviceToken;
  String? phoneNumber;

  UserModel({this.uid, this.email, this.image, this.username, this.isAdmin,this.deviceToken,this.phoneNumber});

  factory UserModel.document(DocumentSnapshot snap) {
    return UserModel(
        uid: snap['uid'],
        username: snap['username'],
        email: snap['email'],
        image: snap['image'],
        isAdmin: snap['isAdmin'],
      deviceToken: snap['deviceToken'],
      phoneNumber:snap['phoneNumber']??'1234'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'image': image,
      'isAdmin': isAdmin,
      'deviceToken':deviceToken,
      'phoneNumber':phoneNumber
    };
  }
}
