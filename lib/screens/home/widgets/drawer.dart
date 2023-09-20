import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon_app_userside/screens/home/widgets/reusable_tile.dart';
import 'package:salon_app_userside/utils/navigations.dart';

import '../../../models/user_model.dart';
import '../../../themes/app_colors.dart';
import '../../auth/widgets/alert_for_logout.dart';
import '../my_appointments.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        UserModel userModel = UserModel.document(snapshot.data!);
        return Drawer(
          backgroundColor: AppColors.primaryBlack,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(userModel.image!),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(color: Colors.blueGrey),
                const SizedBox(height: 20),
                ReusableTile(
                  icon: Icons.calendar_month,
                  title: "My Appointment",
                  onTap: () {
                    navigateToPage(context, const AppointmentsScreen());
                  },
                ),
                ReusableTile(
                  icon: Icons.settings,
                  title: "Settings",
                  onTap: () {},
                ),
                ReusableTile(
                  icon: Icons.person,
                  title: "My Profile",
                  onTap: () {},
                ),
                const Spacer(),
                ReusableTile(
                  icon: Icons.logout_rounded,
                  title: "Log Out",
                  onTap: () {
                    showAlertDialog(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
