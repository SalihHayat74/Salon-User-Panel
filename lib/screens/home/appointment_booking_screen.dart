import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:salon_app_userside/screens/home/widgets/reusable_text.dart';
import 'package:salon_app_userside/services/firestore_constants.dart';
import 'package:salon_app_userside/widgets/buttons.dart';
import 'package:salon_app_userside/models/service_model.dart';
import 'package:salon_app_userside/themes/app_colors.dart';

import '../../models/appointment_date_model.dart';
import '../../models/appointment_model.dart';
import '../../models/appointment_times_model.dart';
import '../../services/notification_services.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final dynamic pdtData;
  String? adminDeviceId;
  AppointmentBookingScreen({Key? key, this.pdtData,this.adminDeviceId}) : super(key: key);

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {

  bool userNameFetched=false;
  String selectedService="";
  String selectedServiceDuration="";
  String? userName;
  String? userPhone;
  fetchUserData()async{
    DocumentSnapshot userSnapshot=await FirebaseFirestore.instance.
    collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();


    if(userSnapshot.exists) {
      userName=userSnapshot['username'];
      userPhone=userSnapshot['phoneNumber'];
      userNameFetched=true;
      setState(() {});
  }
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  String? selectedDate;
  List<TimeOfDay> allSelectedTime = [];
  getDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    setState(() {
      selectedDate = pickedDate!.toString();
    });
  }

  TimeOfDay? selectedTime;
  getTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    selectedTime = pickedTime;
    setState(() {
      print(selectedTime);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.withOpacity(0.5),
        centerTitle: true,
        title: const Text("Book Your Appointment"),
      ),
      body: userNameFetched?StreamBuilder(
        stream: FirebaseFirestore.instance.collection(FirestoreConstants.technicianCollection).
        doc(widget.pdtData['uid']).
        collection(FirestoreConstants.appointmentsCollection).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: ReusableText(
                text:"Technician Not Set Their Availability",
                color: Colors.red,

              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {

              AppointmentDateModel appointmentDateModel=AppointmentDateModel.fromJson(snapshot.data!.docs[index]);
              // print(appointmentDateModel.appointmentDate);
              String appointmentDate=appointmentDateModel.appointmentDate;
              print(appointmentDate);
              String  date=DateFormat.yMMMd().format(DateTime.parse(appointmentDateModel.appointmentDate));
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReusableText(
                          text: date,
                          color: AppColors.primaryWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),

                        const SizedBox(height: 20),
                        const Text("Services"),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection(FirestoreConstants.technicianCollection).
                            doc(widget.pdtData['uid']).collection(FirestoreConstants.appointmentsCollection).
                            doc(snapshot.data!.docs[index].id).collection(FirestoreConstants.servicesCollection).snapshots(),
                            builder: (context, serviceSnapshot) {
                              return serviceSnapshot.hasData?SizedBox(
                                width: MediaQuery.of(context).size.width*.8,
                                height: MediaQuery.of(context).size.width*.2,
                                child: ListView.builder(
                                  itemCount: serviceSnapshot.data!.docs.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context,serviceIndex) {
                                    ServiceModel service=ServiceModel.fromJson(serviceSnapshot.data!.docs[serviceIndex]);
                                    return InkWell(
                                      onTap: (){
                                        if(selectedService.isEmpty){
                                          selectedService=service.serviceName;
                                          selectedServiceDuration=service.serviceDuration;
                                          ScaffoldMessenger.of(context).
                                          showSnackBar(SnackBar(content: Text("$selectedService selected successfully"),duration: const Duration(seconds: 1),));
                                        }else if(selectedService==service.serviceName){
                                          ScaffoldMessenger.of(context).
                                          showSnackBar(SnackBar(content: Text("Already chosen $selectedService"),duration: const Duration(seconds: 1),));
                                        }else{
                                          showDialog(
                                              context: context,
                                              builder: (context){
                                                return AlertDialog(
                                                  content: const Text("Are you sure to change service"),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: PrimaryButton(
                                                            onPressed: () {
                                                              String temp=selectedService;
                                                              selectedService=service.serviceName;
                                                              selectedServiceDuration=service.serviceDuration;
                                                              ScaffoldMessenger.of(context).
                                                              showSnackBar(SnackBar(
                                                                content: Text("Changed Successfully $temp -> $selectedService"),
                                                                duration: const Duration(seconds: 2),));
                                                              Navigator.pop(context);
                                                              setState(() {

                                                              });
                                                            },
                                                            title: "Change",
                                                          ),
                                                        ),
                                                        const SizedBox(width:10),
                                                        Expanded(
                                                          child: PrimaryButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            title: "Cancel",
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: Colors.grey,
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            height: 30,
                                            child: Column(
                                              children: [
                                                ReusableText(
                                                  text:service.serviceName,
                                                  color: AppColors.primaryBlack,
                                                  fontSize:12 ,
                                                  textAlign:TextAlign.center,
                                                ),
                                                ReusableText(
                                                  text:"${service.serviceDuration} Minutes",
                                                  color: AppColors.primaryBlack,
                                                  fontSize:12 ,
                                                  textAlign:TextAlign.center,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ):
                              const Text("No Service Available");
                            }
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Appointment Times"),
                        const SizedBox(height: 10),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("technicians").
                            doc(widget.pdtData['uid']).collection('appointments').
                            doc(snapshot.data!.docs[index].id).collection('appointmentTimes').snapshots(),
                            builder: (context,timeSnapshot){
                              if (!timeSnapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (timeSnapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: ReusableText(
                                    text:"Technician Not Set Their Availability",
                                    color: AppColors.primaryRed,
                                  ),
                                );
                              }
                              return SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width*.9,
                                child: Center(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: timeSnapshot.data!.docs.length,
                                      itemBuilder: (context,tIndex){
                                      AppointmentTimesModel appointmentTime=AppointmentTimesModel.fromJson(timeSnapshot.data!.docs[tIndex]);
                                        return
                                          appointmentTime.isBooked == true?
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.red,
                                            ),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  ReusableText(
                                                    text:appointmentTime.appointmentTime,
                                                    fontSize: 12,
                                                    color: AppColors.primaryBlack,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  ReusableText(
                                                    text:"Booked",
                                                    fontSize: 12,
                                                    color: AppColors.primaryBlack,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ):
                                        InkWell(
                                          onTap: (){
                                            if(selectedService.isEmpty){
                                              ScaffoldMessenger.of(context).
                                            showSnackBar(const SnackBar(content: Text("Please select one service"),duration: Duration(seconds: 1),));
                                            }else {
                                              showDialog(
                                                context: context,
                                                builder: (context){
                                                  return AlertDialog(
                                                    content: StatefulBuilder(
                                                        builder: (context,StateSetter setState) {
                                                          return ReusableText(
                                                            text:"Are you sure to Book Appointment",
                                                            textAlign:TextAlign.center,
                                                              fontWeight:FontWeight.w700,
                                                              fontSize: 18
                                                          );
                                                        }
                                                    ),
                                                    actions: [
                                                      PrimaryButton(
                                                        onPressed: () async {
                                                          // List<String> allSelectedTimeString = allSelectedTime.map((timeOfDay) => timeOfDay.format(context)).toList();
                                                          try {

                                                            String appointmentId=DateTime.now().millisecondsSinceEpoch.toString()+timeSnapshot.data!.docs[tIndex].id;
                                                            String userId=FirebaseAuth.instance.currentUser!.uid;
                                                            final formatter=DateFormat.yMMMd().add_jm();
                                                            EasyLoading.show(status: "Please Wait");
                                                            print(date);
                                                            String technicianId=widget.pdtData['uid'];
                                                            String technicianName="";
                                                            var technicianSnapshot=await FirebaseFirestore.instance.collection(FirestoreConstants.usersCollection).
                                                            doc(technicianId).get();
                                                            if(technicianSnapshot.exists){
                                                              technicianName=technicianSnapshot["username"];
                                                            }
                                                            if(userNameFetched==true){
                                                              AppointmentModel appointment=AppointmentModel(
                                                                technicianName: technicianName,
                                                                  appointmentId: appointmentId,
                                                                  appointmentDate: appointmentDateModel.appointmentDate,
                                                                  appointmentTime: appointmentTime.appointmentTime,
                                                                  bookerId: userId,
                                                                  technicianId: widget.pdtData['uid'],
                                                                  isBooked: true,
                                                                  bookingTime: formatter.format(DateTime.now()),
                                                                  bookerName: userName!,
                                                                  bookerPhone: userPhone!,
                                                                serviceName: selectedService,
                                                                serviceDuration: selectedServiceDuration
                                                              );
                                                              await FirebaseFirestore.instance
                                                                  .collection(FirestoreConstants.appointmentsCollection)
                                                                  .doc(appointmentId).set(appointment.toJson());
                                                              await FirebaseFirestore.instance
                                                                  .collection(FirestoreConstants.technicianCollection)
                                                                  .doc(widget.pdtData['uid'])
                                                                  .collection(FirestoreConstants.appointmentsCollection)
                                                                  .doc(snapshot.data!.docs[index].id).
                                                              collection(FirestoreConstants.appointmentTimesCollection).
                                                              doc(timeSnapshot.data!.docs[tIndex].id).
                                                              update({'isBooked': true,});
                                                            }

                                                            await NotificationServices().sendNotification(widget.adminDeviceId!);
                                                            setState(() {
                                                            });
                                                            EasyLoading.dismiss();
                                                            // ignore: use_build_context_synchronously
                                                            Navigator.of(context).pop();

                                                          } catch (e) {
                                                            EasyLoading.showError(e.toString());
                                                            EasyLoading.dismiss();
                                                          }
                                                        },
                                                        title: "Book",
                                                      ),

                                                    ],
                                                  );
                                                });
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.grey,
                                            ),
                                            child: Center(
                                              child: ReusableText(
                                                text:appointmentTime.appointmentTime,
                                                fontSize: 12,
                                                color: AppColors.primaryBlack,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              );
                            }),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      ):const Center(child: CircularProgressIndicator()),
    );
  }
}
