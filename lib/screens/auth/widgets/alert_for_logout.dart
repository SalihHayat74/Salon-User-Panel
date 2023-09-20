import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/auth_services.dart';

showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return CupertinoAlertDialog(
        title: const Text("Wait"),
        content: const Text("Do you want to Logout?"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop();
              await AuthServices.logOut(context: context);
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}
