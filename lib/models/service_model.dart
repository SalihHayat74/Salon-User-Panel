

import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModelFields{
  static const String serviceName='serviceName';
  static const String serviceDuration='serviceDuration';
}


class ServiceModel{
  String serviceName;
  String serviceDuration;

  ServiceModel({
   required this.serviceName,
   required this.serviceDuration
});

  Map<String,dynamic> toJson()=>{
    ServiceModelFields.serviceName:serviceName,
    ServiceModelFields.serviceDuration:serviceDuration
  };

  factory ServiceModel.fromJson(DocumentSnapshot json)=>ServiceModel(
      serviceName: json[ServiceModelFields.serviceName],
      serviceDuration: json[ServiceModelFields.serviceDuration]);

}