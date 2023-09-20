import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_app_userside/screens/home/widgets/product_card.dart';
import 'package:salon_app_userside/themes/app_colors.dart';

class NailPolishDetailScreen extends StatelessWidget {
  final String? uid;
  final String? deviceId;
  const NailPolishDetailScreen({Key? key, this.uid,this.deviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.withOpacity(0.5),
        title: const Text("Detail"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').where('uid', isEqualTo: uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No Data is Uploaded Yet",
                  style: TextStyle(
                    color: AppColors.btnColor,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var pdtData = snapshot.data!.docs[index];
                return ProductCard(pdtData: pdtData,adminDeviceId: deviceId!,);
              },
            );
          },
        ),
      ),
    );
  }
}
