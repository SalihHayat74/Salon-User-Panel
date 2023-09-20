import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:salon_app_userside/models/appointment_model.dart';
import 'package:salon_app_userside/models/appointment_times_model.dart';
import 'package:salon_app_userside/models/service_model.dart';
import 'package:salon_app_userside/models/user_model.dart';
import 'package:salon_app_userside/screens/home/nail_polish_detail_page.dart';
import 'package:salon_app_userside/screens/home/widgets/drawer.dart';
import 'package:salon_app_userside/screens/home/widgets/reusable_text.dart';
import 'package:salon_app_userside/themes/app_colors.dart';
import 'package:salon_app_userside/utils/navigations.dart';

import '../../models/appointment_date_model.dart';
import '../../services/firestore_constants.dart';
import '../../services/notification_services.dart';
import '../../widgets/buttons.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String selectedDate="Select Date";
  String selectedTechnician="Select Technician";
  String selectedServiceName="Select Service";
  TimeOfDay ? selectedTime;
  String selectedTechnicianDocID='';

  UserModel ? customerData;
  bool userDataFetched=false;
  fetchCustomerData()async{
    var data=await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if(data.exists){
      customerData=UserModel.document(data);
      setState(() {
        userDataFetched=true;
      });
    }
  }

  List<String> appointmentDatesStringList=[];
  List<String> appointmentDatesDocId=[];
  List<AppointmentDateModel> technicianAppointmentDatesList=[];
  fetchTechnicianDates(String technicianDocId)async{
    QuerySnapshot snapshot=await FirebaseFirestore.instance.collection(FirestoreConstants.technicianCollection).
    doc(technicianDocId).collection(FirestoreConstants.appointmentsCollection).get();

    print(technicianDocId);
    if(snapshot.docs.isNotEmpty){
      appointmentDatesStringList.clear();
      technicianAppointmentDatesList.clear();
      appointmentDatesDocId.clear();
      for(int i=0;i<snapshot.docs.length;i++){
        AppointmentDateModel appointment=AppointmentDateModel.fromJson(snapshot.docs[i]);
        technicianAppointmentDatesList.add(appointment);
        appointmentDatesStringList.add(appointment.appointmentDate);
        appointmentDatesDocId.add(snapshot.docs[i].id);
      }
      setState(() {

      });
    }else{
      appointmentDatesStringList.clear();
      technicianAppointmentDatesList.clear();
      appointmentDatesDocId.clear();
      servicesList.clear();
      serviceNamesList.clear();
      appointmentTimesList.clear();
      appointmentTimesStringList.clear();
      appointmentTimesIdsList.clear();

      setState(() {

      });
    }
  }

  List<ServiceModel> servicesList=[];
  List<String> serviceNamesList=[];
  fetchTechnicianServices(String technicianAppointmentId,String technicianDocId)async{
    QuerySnapshot snapshot=await FirebaseFirestore.instance.collection(FirestoreConstants.servicesCollection).get();
    // doc(technicianDocId).collection(FirestoreConstants.appointmentsCollection).
    // doc(technicianAppointmentId).collection(FirestoreConstants.servicesCollection).get();
    if(snapshot.docs.isNotEmpty){
      print("services is not empty");
      servicesList.clear();
      serviceNamesList.clear();
      for(int i=0;i<snapshot.docs.length;i++){
        ServiceModel service=ServiceModel.fromJson(snapshot.docs[i]);
        servicesList.add(service);
        serviceNamesList.add(service.serviceName);
      }
      print(serviceNamesList.length);
      setState(() {

      });
    }else{
      servicesList.clear();
      serviceNamesList.clear();
      setState(() {

      });
    }
  }

  List<AppointmentTimesModel> appointmentTimesList=[];
  List<String> appointmentTimesStringList=[];
  List<String>appointmentTimesIdsList=[];
  fetchTechnicianTimes(String technicianAppointmentId,String technicianDocId)async{
    QuerySnapshot snapshot=await FirebaseFirestore.instance.collection(FirestoreConstants.technicianCollection).
    doc(technicianDocId).collection(FirestoreConstants.appointmentsCollection).
    doc(technicianAppointmentId).collection(FirestoreConstants.appointmentTimesCollection).get();
    if(snapshot.docs.isNotEmpty){
      appointmentTimesList.clear();
      appointmentTimesStringList.clear();
      appointmentTimesIdsList.clear();
      for(int i=0;i<snapshot.docs.length;i++){
        AppointmentTimesModel appointmentTimesModel=AppointmentTimesModel.fromJson(snapshot.docs[i]);
        appointmentTimesList.add(appointmentTimesModel);
        appointmentTimesStringList.add(appointmentTimesModel.appointmentTime);
        appointmentTimesIdsList.add(snapshot.docs[i].id);
      }
      setState(() {

      });
    }else{
      appointmentTimesList.clear();
      appointmentTimesStringList.clear();
      appointmentTimesIdsList.clear();
      setState(() {

      });
    }
  }


  // String? selectedDateOfMonth;
  // List<TimeOfDay> allSelectedTime = [];
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

  // TimeOfDay? selectedTimeOfDay;
  getTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      selectedTime = pickedTime;
      // allSelectedTime.add(selectedTimeOfDay!);
      // print(allSelectedTime);
    });
    if(selectedTime!=null) {
      QuerySnapshot snap=await FirebaseFirestore.instance.collection(FirestoreConstants.appointmentsCollection).
    where(AppointmentModelFields.appointmentDate,isEqualTo: selectedDate).where(AppointmentModelFields.technicianName,isEqualTo: selectedTechnician).
    where(AppointmentModelFields.appointmentTime,isEqualTo: selectedTime!.format(context)).get();
      print(snap.docs.length);
      if(snap.docs.isNotEmpty){
        EasyLoading.showToast("Time already booked",duration: const Duration(seconds: 3),toastPosition: EasyLoadingToastPosition.bottom);
        selectedTime=null;
        setState(() {

        });
      }
    }


  }


  @override
  initState(){
    fetchCustomerData();
    fetchTechnicianServices('String technicianAppointmentId',"123");
    super.initState();
  }
  List<UserModel> technicianList=[];
  List<String> technicianNamesList=[];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return await showDialog(context: context,
            builder: (context){
              return AlertDialog(
                content: const Text("Are you sure exit"),
                actions: [
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () async{
                            Navigator.pop(context,false);
                          },
                          title: "Stay",

                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () async{
                            Navigator.pop(context,true);
                          },
                          title: "Exit",
                        ),
                      ),
                    ],
                  ),

                ],
              );
            });
      },
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlack,
          title: const Text("Home Screen"),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').where('isAdmin', isEqualTo: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Data is Uploaded Yet"),
                );
              }
              technicianList.clear();
              technicianNamesList.clear();
              for(int i=0;i<snapshot.data!.docs.length;i++){
                var userInfo=UserModel.document(snapshot.data!.docs[i]);
                technicianList.add(userInfo);
                technicianNamesList.add(userInfo.username!);
              }
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userDataFetched?Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(text: "Name ",color: AppColors.primaryWhite,fontSize: 16,),
                            const SizedBox(height: 10,),
                            ReusableText(text: "Ph# ",color: AppColors.primaryWhite,fontSize: 16),
                            const SizedBox(height: 10,),
                            ReusableText(text: "Email",color: AppColors.primaryWhite,fontSize: 16),
                          ],
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            ReusableText(text: customerData!.username!,color: AppColors.primaryWhite,fontSize: 16,),
                            const SizedBox(height: 10,),
                            ReusableText(text: customerData!.phoneNumber!,color: AppColors.primaryWhite,fontSize: 16),
                            const SizedBox(height: 10,),
                            ReusableText(text: customerData!.email!,color: AppColors.primaryWhite,fontSize: 16),
                          ],
                        ),
                      ],
                    ):const SizedBox(),

                    const SizedBox(height: 20,),
                    ReusableText(text: "Select Technician",color: AppColors.primaryWhite),
                    const SizedBox(height: 5,),
                    Container(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      color: AppColors.primaryWhite,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconDisabledColor: Colors.black,
                          iconEnabledColor: Colors.black,
                          dropdownColor: const Color(0xFFD6D6D6),
                          isExpanded: true,
                          onTap: ()async{
                            // print(context.watch<InventoryProvider>().selected);


                          },
                          borderRadius: BorderRadius.circular(20),
                          hint: Text(selectedTechnician),
                          items: technicianNamesList.map((String items) {
                            return DropdownMenuItem<String>(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          //
                          // value: selected,
                          onChanged: (String? newValue) async {

                            selectedTechnician=newValue!;
                            // selectedTechnicianDocID=technicianList[technicianNamesList.indexOf(selectedTechnician)].uid!;
                            // fetchTechnicianDates(technicianList[technicianNamesList.indexOf(selectedTechnician)].uid!);
                            setState(() {

                            });

                          },


                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ReusableText(text: "Select Date",color: AppColors.primaryWhite),
                    const SizedBox(height: 5,),
                    InkWell(
                      onTap: (){
                        getDate();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 5,right: 5),
                        color: AppColors.primaryWhite,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: const Color(0xFFD6D6D6),
                            isExpanded: true,
                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            onTap: ()async{
                              await getDate();
                              // print(context.watch<InventoryProvider>().selected);
                            },
                            borderRadius: BorderRadius.circular(20),
                            hint: selectedDate=="Select Date"?Text(selectedDate):Text(DateFormat.yMMMd().format(DateTime.parse(selectedDate))),
                            items: appointmentDatesStringList.map((String items) {
                              return DropdownMenuItem<String>(
                                value: items,
                                child: Text(DateFormat.yMMMd().format(DateTime.parse(items))),
                              );
                            }).toList(),
                            //
                            // value: selected,
                            onChanged: (String? newValue) async {
                              selectedDate=newValue!;

                              // fetchTechnicianServices(appointmentDatesDocId.elementAt(appointmentDatesStringList.indexOf(selectedDate)), selectedTechnicianDocID);
                              // fetchTechnicianTimes(appointmentDatesDocId.elementAt(appointmentDatesStringList.indexOf(selectedDate)), selectedTechnicianDocID);

                              setState(() {

                              });
                            },


                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ReusableText(text: "Select Service",color: AppColors.primaryWhite),
                    const SizedBox(height: 5,),
                    Container(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      color: AppColors.primaryWhite,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconDisabledColor: Colors.black,
                          iconEnabledColor: Colors.black,
                          dropdownColor: const Color(0xFFD6D6D6),
                          isExpanded: true,
                          onTap: ()async{
                            // print(context.watch<InventoryProvider>().selected);


                          },
                          borderRadius: BorderRadius.circular(20),
                          hint: Text(selectedServiceName),
                          items: serviceNamesList.map((String items) {
                            return DropdownMenuItem<String>(
                              value: items,
                              child: Row(

                                children: [
                                  Text(items),
                                  const Spacer(),
                                  Text("Duration: ${servicesList.elementAt(serviceNamesList.indexOf(items)).serviceDuration}"),
                                ],
                              ),
                            );
                          }).toList(),
                          //
                          // value: selected,
                          onChanged: (String? newValue) async {
                            selectedServiceName=newValue!;
                            setState(() {

                            });

                          },


                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ReusableText(text: "Select Time",color: AppColors.primaryWhite),
                    const SizedBox(height: 5,),
                    InkWell(
                      onTap: (){
                        getTime();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 5,right: 5),
                        color: AppColors.primaryWhite,

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            iconDisabledColor: Colors.black,
                            iconEnabledColor: Colors.black,
                            dropdownColor: const Color(0xFFD6D6D6),
                            isExpanded: true,
                            onTap: ()async{
                              // print(context.watch<InventoryProvider>().selected);


                            },
                            borderRadius: BorderRadius.circular(20),
                            hint: selectedTime!=null?Text(selectedTime!.format(context)):const Text("Select Time"),
                            items: appointmentTimesStringList.map((String items) {
                              return DropdownMenuItem<String>(
                                value: items,
                                child: appointmentTimesList.elementAt(appointmentTimesStringList.indexOf(items)).isBooked==true? Text("$items booked",style: const TextStyle(color:Colors.red),):Text(items),
                              );
                            }).toList(),
                            onChanged: (String? value) {  },
                            //
                            // value: selected,



                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30,),
                    PrimaryButton(
                      onPressed: () async {
                        // List<String> allSelectedTimeString = allSelectedTime.map((timeOfDay) => timeOfDay.format(context)).toList();
                        try {
                          if(selectedTechnician=="Select Technician"){
                            EasyLoading.showError("Technician must be selected");
                          }else if(selectedDate =="Select Date"){
                            EasyLoading.showError("Date must be selected");
                          }else if(selectedServiceName=="Select Service"){
                            EasyLoading.showError("Service must be selected");
                          }else if(selectedTime==null){
                            EasyLoading.showError("Time must be selected");
                          }else{
                            EasyLoading.show(status: "Please Wait");
                            String appointmentId=DateTime.now().millisecondsSinceEpoch.toString();
                            String userId=FirebaseAuth.instance.currentUser!.uid;
                            final formatter=DateFormat.yMMMd().add_jm();

                            AppointmentModel appointment=AppointmentModel(
                                technicianName: selectedTechnician,
                                appointmentId: appointmentId,
                                appointmentDate: selectedDate,
                                appointmentTime: selectedTime!.format(context),
                                bookerId: userId,
                                technicianId: technicianList.elementAt(technicianNamesList.indexOf(selectedTechnician)).uid!,
                                isBooked: true,
                                bookingTime: formatter.format(DateTime.now()),
                                bookerName: customerData!.username!,
                                bookerPhone: customerData!.phoneNumber!,
                                serviceName: selectedServiceName,
                                serviceDuration: servicesList.elementAt(serviceNamesList.indexOf(selectedServiceName)).serviceDuration
                            );
                            QuerySnapshot snap=await FirebaseFirestore.instance.collection(FirestoreConstants.appointmentsCollection).
                            where(AppointmentModelFields.appointmentDate,isEqualTo: selectedDate).
                            where(AppointmentModelFields.technicianName,isEqualTo: selectedTechnician).
                            where(AppointmentModelFields.serviceName,isEqualTo: selectedServiceName).
                            where(AppointmentModelFields.appointmentTime,isEqualTo: selectedTime!.format(context)).get();
                            print(snap.docs.length);
                            if(snap.docs.isNotEmpty){
                              EasyLoading.showToast("Appointment Already Exists",duration: const Duration(seconds: 3),toastPosition: EasyLoadingToastPosition.bottom);
                              selectedTime=null;
                              selectedDate="Select Date";
                              selectedServiceName="Select Service";
                              selectedTechnician="Select Technician";
                              setState(() {

                              });
                            }else{
                              await FirebaseFirestore.instance
                                  .collection(FirestoreConstants.appointmentsCollection)
                                  .doc(appointmentId).set(appointment.toJson()).then((value) async{
                                await NotificationServices().sendNotification(technicianList.elementAt(technicianNamesList.indexOf(selectedTechnician)).deviceToken!);
                                EasyLoading.showToast("Successfully booked appointment",
                                    duration: const Duration(seconds: 3),toastPosition: EasyLoadingToastPosition.bottom);
                                selectedTime=null;
                                selectedDate="Select Date";
                                selectedServiceName="Select Service";
                                selectedTechnician="Select Technician";
                                setState(() {
                                });
                                EasyLoading.dismiss();
                              }).catchError((error){
                                EasyLoading.showToast("Failed due to $error",duration: const Duration(seconds: 3));
                                EasyLoading.dismiss();
                              });
                            }


                            // await FirebaseFirestore.instance
                            //     .collection(FirestoreConstants.technicianCollection)
                            //     .doc(technicianList.elementAt(technicianNamesList.indexOf(selectedTechnician)).uid!)
                            //     .collection(FirestoreConstants.appointmentsCollection)
                            //     .doc(appointmentDatesDocId.elementAt(appointmentDatesStringList.indexOf(selectedDate))).
                            // collection(FirestoreConstants.appointmentTimesCollection).
                            // doc(appointmentTimesIdsList.elementAt(appointmentTimesStringList.indexOf(selectedTime!.format(context)))).
                            // update({'isBooked': true,});
                            //
                            // fetchTechnicianServices(appointmentDatesDocId.elementAt(appointmentDatesStringList.indexOf(selectedDate)), selectedTechnicianDocID);
                            // fetchTechnicianTimes(appointmentDatesDocId.elementAt(appointmentDatesStringList.indexOf(selectedDate)), selectedTechnicianDocID);


                          }

                          // ignore: use_build_context_synchronously
                          // Navigator.of(context).pop();

                        } catch (e) {
                          EasyLoading.showError(e.toString());
                          EasyLoading.dismiss();
                        }
                      },
                      title: "Book Appointment",
                    ),

                  ],
                ),
              );
                
                
              //   GridView.builder(
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     mainAxisSpacing: 10,
              //     crossAxisSpacing: 10,
              //   ),
              //   itemCount: snapshot.data!.docs.length,
              //   itemBuilder: (context, index) {
              //     UserModel userModel = UserModel.document(snapshot.data!.docs[index]);
              //
              //     return InkWell(
              //       onTap: (){
              //         print(userModel.uid!);
              //         navigateToPage(
              //           context,
              //           NailPolishDetailScreen(
              //             uid: userModel.uid!,
              //             deviceId: userModel.deviceToken,
              //           ));},
              //       child: Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //         height: 200,
              //         width: 200,
              //         decoration: BoxDecoration(
              //           color: Colors.red,
              //           borderRadius: BorderRadius.circular(08),
              //           image: DecorationImage(
              //             image: NetworkImage(userModel.image!),
              //             fit: BoxFit.cover,
              //             colorFilter: ColorFilter.mode(AppColors.primaryBlack.withOpacity(0.45), BlendMode.srcATop),
              //           ),
              //         ),
              //         child: Center(
              //           child: Text(
              //             userModel.username!,
              //             style: TextStyle(
              //               color: AppColors.primaryWhite,
              //               fontSize: 17,
              //             ),
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // );
            }),
      ),
    );
  }
}
