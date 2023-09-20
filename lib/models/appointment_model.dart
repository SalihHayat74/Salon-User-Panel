

import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModelFields{
  static const String appointmentId='appointmentId';
  static const String appointmentDate='appointmentDate';
  static const String appointmentTime='appointmentTime';
  static const String bookerId='bookerId';
  static const String technicianId='technicianId';
  static const String technicianName='technicianName';
  static const String isBooked='isBooked';
  static const String bookingTime='bookingTime';
  static const String bookerName='bookerName';
  static const String bookerPhone='bookerPhone';
  static const String serviceName='serviceName';
  static const String serviceDuration='serviceDuration';
}

class AppointmentModel{
  String appointmentId;
  String appointmentDate;
  String appointmentTime;
  String bookerId;
  String technicianId;
  bool isBooked;
  String bookingTime;
  String bookerName;
  String bookerPhone;
  String serviceName;
  String serviceDuration;
  String technicianName;

  AppointmentModel({
    required this.appointmentId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.bookerId,
    required this.technicianId,
    required this.isBooked,
    required this.bookingTime,
    required this.bookerName,
    required this.bookerPhone,
    required this.serviceName,
    required this.serviceDuration,
    required this.technicianName
});

  Map<String,dynamic> toJson()=>{
    AppointmentModelFields.appointmentId:appointmentId,
    AppointmentModelFields.appointmentDate:appointmentDate,
    AppointmentModelFields.appointmentTime:appointmentTime,
    AppointmentModelFields.technicianId:technicianId,
    AppointmentModelFields.bookerId:bookerId,
    AppointmentModelFields.isBooked:isBooked,
    AppointmentModelFields.bookingTime:bookingTime,
    AppointmentModelFields.bookerName:bookerName,
    AppointmentModelFields.bookerPhone:bookerPhone,
    AppointmentModelFields.serviceName:serviceName,
    AppointmentModelFields.serviceDuration:serviceDuration,
    AppointmentModelFields.technicianName:technicianName
  };

  factory AppointmentModel.fromJson(DocumentSnapshot json)=>AppointmentModel(
      appointmentId: json[AppointmentModelFields.appointmentId],
      appointmentDate: json[AppointmentModelFields.appointmentDate],
      appointmentTime: json[AppointmentModelFields.appointmentTime],
      bookerId: json[AppointmentModelFields.bookerId],
      technicianId: json[AppointmentModelFields.technicianId],
      isBooked: json[AppointmentModelFields.isBooked],
    bookingTime: json[AppointmentModelFields.bookingTime],
    bookerName: json[AppointmentModelFields.bookerName],
    bookerPhone: json[AppointmentModelFields.bookerPhone],
    serviceName: json[AppointmentModelFields.serviceName],
    serviceDuration: json[AppointmentModelFields.serviceDuration],
    technicianName: json[AppointmentModelFields.technicianName]
  );

}