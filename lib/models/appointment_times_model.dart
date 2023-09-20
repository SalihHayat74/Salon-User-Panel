



import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentTimesModelFields{
  static const String isBooked="isBooked";
  static const String appointmentTime="appointmentTime";
}

class AppointmentTimesModel{
  bool isBooked;
  String appointmentTime;

  AppointmentTimesModel({
   required this.isBooked,
   required this.appointmentTime
});

  Map<String,dynamic> toMap()=>{
    AppointmentTimesModelFields.isBooked:isBooked,
    AppointmentTimesModelFields.appointmentTime:appointmentTime
  };

  factory AppointmentTimesModel.fromJson(DocumentSnapshot json)=>AppointmentTimesModel(
      isBooked: json[AppointmentTimesModelFields.isBooked],
      appointmentTime: json[AppointmentTimesModelFields.appointmentTime]);

}