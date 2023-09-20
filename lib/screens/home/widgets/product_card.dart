import 'package:flutter/material.dart';
import 'package:salon_app_userside/screens/home/appointment_booking_screen.dart';
import 'package:salon_app_userside/utils/navigations.dart';

import '../../../themes/app_colors.dart';
import '../appointment_booking_screen.dart';

class ProductCard extends StatelessWidget {
  final dynamic pdtData;
  final String adminDeviceId;
  const ProductCard({Key? key, this.pdtData,required this.adminDeviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToPage(context, AppointmentBookingScreen(pdtData: pdtData,adminDeviceId: adminDeviceId,));
      },
      child: Card(
        elevation: 12,
        color: Colors.blueGrey.withOpacity(0.7),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 08, vertical: 08),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(08),
                    child: Image.network(
                      pdtData['pdtImage'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pdtData['pdtName'],
                      style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 03),
                    Text(
                      "Price: \$ ${pdtData['pdtAmount']}",
                      style: TextStyle(
                        color: AppColors.primaryWhite.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "${pdtData['duration']} min",
                  style: TextStyle(
                    color: AppColors.primaryWhite.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
