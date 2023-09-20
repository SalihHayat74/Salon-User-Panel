import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon_app_userside/services/firestore_constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/appointment_model.dart';
import '../../themes/app_colors.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {


  fetchTechnicianInfo(String technicianId)async{
    FirebaseFirestore instance=FirebaseFirestore.instance;
    var snapshot=await instance.collection(FirestoreConstants.usersCollection).
    doc(technicianId).get();
    if(snapshot.exists){

    }
  }

  final Map<DateTime, List<dynamic>> _events={};
  List<AppointmentModel> appointmentList=[];
  final List<AppointmentModel> _selectedEvents=[];


  bool visibleEvents=false;
  DateTime? _focusedDay=DateTime.now();
  DateTime? _selectedDay;

  bool isCalendar=true;
  bool isTable=false;

  @override
  Widget build(BuildContext context) {

    // List<Event> _getEventsForDay(DateTime day) {
    //   return events[day] ?? [];
    // }



    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        title: const Text("My Appointments"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("appointments")
            .where("bookerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Data Found ",
                style: TextStyle(
                  color: AppColors.primaryWhite,
                ),
              ),
            );
          }

          appointmentList.clear();
          for(int i=0;i<snapshot.data!.docs.length;i++){
            AppointmentModel appointments=AppointmentModel.fromJson(snapshot.data!.docs[i]);
            appointmentList.add(appointments);
          }
          print(appointmentList.length);

          return Container(
            decoration: const BoxDecoration(
                color: Colors.white
            ),
            child: Column(
              children: [

                TableCalendar(
                  // eventLoader: (day){
                  //   return events[day] ?? [];
                  // },
                  focusedDay: _focusedDay!,
                  firstDay: DateTime(2023,01,01),
                  lastDay: DateTime(2030,01,01),
                  selectedDayPredicate: (day) =>isSameDay(day, _selectedDay),
                  onDaySelected: (date,newDate)async{
                    String datte=date.toString().replaceAll('Z', '');

                    // print(currentDate);
                    _selectedEvents.clear();
                    if(appointmentList.isNotEmpty && appointmentList.any((element){

                      return element.appointmentDate==datte.toString();
                    })){


                      for(int i=0;i<appointmentList.length;i++){
                        if(appointmentList[i].appointmentDate==datte){

                          _selectedEvents.add(appointmentList[i]);
                        }else{

                        }
                      }

                      _focusedDay=date;
                      visibleEvents=true;
                      setState(() {

                      });


                      _selectedDay=date;

                    }else{

                      appointmentList.clear();
                      _selectedEvents.clear();
                      _selectedDay=date;
                      visibleEvents=false;
                      setState(() {

                      });
                    }

                    // print("I am selectedd");
                    // print(time);
                    // print(date);
                  },
                  calendarFormat: CalendarFormat.month,

                  // selectedDayPredicate: (date){
                  //     return true;
                  // },
                  calendarStyle:const CalendarStyle(
                      canMarkersOverflow: true,
                      markerDecoration: BoxDecoration(
                        color: Colors.green,
                      ),

                      todayDecoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      selectedDecoration: BoxDecoration(
                          color: Colors.blue
                      )
                  ),
                  headerStyle:HeaderStyle(
                    titleCentered: true,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    formatButtonTextStyle: const TextStyle(color: Colors.white),
                    formatButtonShowsNext: false,
                  ),
                  calendarBuilders:CalendarBuilders(
                    markerBuilder: (context,date,List<AppointmentModel>appointmentsList){
                      appointmentsList=appointmentList;
                      // print("I am marker builder");
                      if(appointmentsList.isEmpty){
                        print("I am marker builder");
                        return null;
                      }else if(appointmentsList.any((element){
                        return element.appointmentDate==date.toString().replaceAll('Z', '');
                      })){
                        return Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Text(
                                  date.day.toString(),textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const Icon(Icons.star,color: Colors.blue,size: 8,)
                              ],
                            ));
                      }
                    },
                    selectedBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                    todayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                Visibility(
                    visible: visibleEvents,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*.333,
                      child: ListView.builder(
                          itemCount: _selectedEvents.length,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: MediaQuery.of(context).size.height/6,

                                width: MediaQuery.of(context).size.width/4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey)
                                ),
                                child: Center(
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text("Technician Name:",
                                              style: TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text("Service Name:",
                                              style: TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text("Service Duration:",
                                              style: TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text("Appointment Time:",
                                              style: TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text("Booking Time:",
                                              style: TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width:8,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(_selectedEvents[index].technicianName,
                                              style: const TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text(_selectedEvents[index].serviceName,
                                              style: const TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text("${_selectedEvents[index].serviceDuration} minutes",
                                              style: const TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text(_selectedEvents[index].appointmentTime,
                                              style: const TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                            Text(_selectedEvents[index].bookingTime,
                                              style: const TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            );
                          }),
                    )),

              ],
            ),
          );

        },
      ),
    );
  }
}
