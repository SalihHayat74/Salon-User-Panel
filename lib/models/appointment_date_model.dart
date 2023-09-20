


import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDateModelFields{
  static const String appointmentDate="appointmentDate";
}

class AppointmentDateModel{
  String appointmentDate;

  AppointmentDateModel({
    required this.appointmentDate
});

  Map<String,dynamic> toMap()=>{
    AppointmentDateModelFields.appointmentDate:appointmentDate
  };

  factory AppointmentDateModel.fromJson(DocumentSnapshot json)=>AppointmentDateModel(
      appointmentDate: json[AppointmentDateModelFields.appointmentDate]);
}