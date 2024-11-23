import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pethotel/controller/styleController.dart';
import 'package:pethotel/controller/widgetController.dart';
import 'package:provider/provider.dart';

import '../../controller/chatController.dart';
import '../../controller/dataController.dart';
import '../../controller/userController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/chatRoomModel.dart';
import '../../model/messagesModel.dart';
import '../../model/petCareModel.dart';
import '../../model/petOwnerModel.dart';
import '../../model/servicesFireBaseModel.dart';

class CarProviderSchedule extends StatefulWidget {
  const CarProviderSchedule({super.key ,required this.careProviderSlots});
  final Map<String, dynamic> careProviderSlots ;
  @override
  State<CarProviderSchedule> createState() => _CarProviderScheduleState();
}

class _CarProviderScheduleState extends State<CarProviderSchedule> {
  List<CarProviderSlot>? careProviderSlots ;
  PetCareProfile? carProviderData ;
  List<Services> myServicesList  = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      await getData();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MyStyle.mainColor,
        onPressed: (){
          if(myServicesList.isEmpty){
            CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Empty services"
                , text: "Please go to your profile and add some services");
          } else {
            showAddSlotDialog(context);
          }

        },
        label: Text("Add Slot" , style: textStyle(color: MyStyle.white , fontSize: 16),),
        icon: Icon(Icons.add , color: MyStyle.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top :8.0 , bottom: 8 , right: 15 , left: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0 , bottom: 8.0),
                child: Text("My Schedule" , style: textStyle(fontSize: 16 , fontWeight: FontWeight.w600),),
              ),
              if(careProviderSlots != null)
                Center(child: Align(alignment: Alignment.center, child:
                Column(
                  children: List.generate(careProviderSlots!.length, (index) {
                    final item =  careProviderSlots![index];
                    return Card(
                      child: ListTile(
                        onTap: () async {
                                  if (item.petOwnerId != null) {
                                    // CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading ,autoCloseDuration:  const Duration(seconds: 2));
                                    final petOwnerProfile =
                                        await Provider.of<DataController>(
                                                context,
                                                listen: false)
                                            .getPetOwnerProfile(
                                                item.petOwnerId ?? "");
                                    if (petOwnerProfile != null) {

                                      final chatRoom = ChatRoomModel(
                                        petOwnerId: item.petOwnerId,
                                        petOwnerName: "${petOwnerProfile.firstName} ${petOwnerProfile.lastName}",
                                        isPetCare: true,
                                        hotelName: "${carProviderData?.hotelName ?? ""}",
                                        petCareUserId: FirebaseAuth.instance.currentUser!.uid,
                                        message: MessageModel(
                                          message: '',
                                        ),
                                      );
                                      ///
                                      await ChatController().createChatRoom(chatRoom: chatRoom ,slotID: item.slotID??"");
                                      ///
                                      // final room = ChatRoomModel(
                                      //   petOwnerId: item.petOwnerId,
                                      //   petOwnerName: "${petOwnerProfile.firstName} ${petOwnerProfile.lastName}",
                                      //   isPetCare: true,
                                      //   hotelName:
                                      //       "${carProviderData?.hotelName ?? ""}",
                                      //   petCareUserId: FirebaseAuth
                                      //       .instance.currentUser!.uid,
                                      //   message: MessageModel(
                                      //     message: '',
                                      //     readed: false,
                                      //   ),
                                      // );
                                    Navigator.pushNamed(
                                        context, '/SlotDetailsPage',
                                        arguments: item);
                                    }
                                  }

                                  else {
                                    Navigator.pushNamed(
                                        context, '/SlotDetailsPage',
                                        arguments: item);
                                  }
                                },
                                title: Text(
                                  "Slot on: ${item.date}",
                          style: textStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "Time: ${item.fromTime}",
                          style: textStyle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          item.status?.toUpperCase() ?? "",
                          style: textStyle(),
                        ),
                      ),
                    );

                  }),
                )
                )),
              if(careProviderSlots != null && careProviderSlots!.isEmpty)
                Center(child: Text("There is no slot" , style: textStyle(),)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading ,autoCloseDuration:  const Duration(seconds: 2));
    myServicesList.clear();
    await Provider.of<DataController>(context, listen: false).fetchCareProviderServicesFromFirestore(myServicesList ,mine: true);
    //
    String? user_id = await Provider.of<DataController>(context, listen: false).getCareProviderAccountByEmail(widget.careProviderSlots["email"]);
    if (user_id != null) {
      await Provider.of<UserController>(context, listen: false).getCareProviderSchedule(user_id ?? "");
      careProviderSlots = Provider.of<UserController>(context, listen: false).userCarProviderSchedule;
      await Provider.of<UserController>(context, listen: false).getCareProviderProfile(user_id ?? "");
      carProviderData = Provider.of<UserController>(context, listen: false).userCarProviderProfile;
      setState(() {});
    }
  }


  void showAddSlotDialog(BuildContext context) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    Services? selectedService;
    String? price; // New variable to hold the price input

    // Create a stateful dialog to manage selected date and time
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: MyStyle.grey200,
              title: Text('Add Slot' , style: textStyle(fontWeight: FontWeight.w500  , fontSize: 16),),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[

                    Text('Select Service', style: textStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Services>(
                            hint: Text('Choose a service' , style: textStyle(fontSize: 13),),
                            value: selectedService,

                            onChanged: (Services? newValue) {
                              setState(() {
                                selectedService = newValue;
                              });
                            },
                            items: myServicesList.map((Services service) {
                              return DropdownMenuItem<Services>(
                                value: service,
                                child: Text(service.name??"" , style: textStyle(fontSize: 13),),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),


                    // New TextField for price input
                    Text('Enter Price:', style: textStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    price = value; // Update price value
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding:  const EdgeInsets.all(0.0),
                                    border: InputBorder.none, // Remove underline
                                  hintText: 'Enter price',
                                  hintStyle: textStyle(fontSize: 13)
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: TextField(
                                  enabled: false,
                                  onChanged: (value) {
                                    setState(() {
                                      price = value; // Update price value
                                    });
                                  },
                                    textAlign: TextAlign.center, // Centering the text
                                  decoration: InputDecoration(
                                      contentPadding:  const EdgeInsets.all(0.0),
                                      border: InputBorder.none, // Remove underline
                                      hintText: "SAR",
                                      hintStyle: textStyle(fontSize: 13)
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text('Select Date and Time', style: textStyle(  fontSize: 16),),
                    SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextButton(
                          onPressed: () async {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          },
                          child: Text('Select Date', style: textStyle(  fontSize: 13),),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextButton(
                          onPressed: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                selectedTime = time;
                              });
                            }
                          },
                          child: Text('Select Time', style: textStyle(  fontSize: 13),),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    
                    if (selectedDate != null && selectedTime != null) ...[
                      Text('Selected Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'),
                      Text('Selected Time: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'),
                    ] else if (selectedDate != null) ...[
                      Text('Selected Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'),
                    ] else if (selectedTime != null) ...[
                      Text('Selected Time: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel' , style: textStyle(fontWeight: FontWeight.w500 , color: MyStyle.mainColor),),
                ),
                TextButton(
                  onPressed: () async {

                   if(price == null || int.tryParse(price!) == null){
                     CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Please enter the correct price");
                   }
                   else if (selectedDate != null && selectedTime != null && selectedService != null) {

                     DateTime newSlotDateTime = DateTime(
                       selectedDate!.year,
                       selectedDate!.month,
                       selectedDate!.day,
                       selectedTime!.hour,
                       selectedTime!.minute,
                     );
                     careProviderSlots ??= [];
                     bool slotExists = careProviderSlots!.any((slot) {
                       List<String> dateParts = slot.date!.split('-');
                       List<String> timeParts = slot.fromTime!.split(':');
                       DateTime existingSlotDateTime = DateTime(
                         int.parse(dateParts[2]), // year
                         int.parse(dateParts[1]), // month
                         int.parse(dateParts[0]), // day
                         int.parse(timeParts[0]), // hour
                         int.parse(timeParts[1]), // minute
                       );

                       return existingSlotDateTime.isAtSameMomentAs(newSlotDateTime);
                     });
                     if (slotExists) {
                       CoolAlert.show(
                         context: context,
                         type: CoolAlertType.error,
                         width: 400,
                         title: "Slot already exists",
                         text: "A slot already exists for this date and time.",
                       );
                       return; // Exit the function to prevent adding the slot
                     }

                      CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading);
                      String formattedDate = "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
                      String formattedTime = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
                      // Handle the slot creation here
                      print("Slot added for date: $formattedDate at time: $formattedTime");
                      // Navigator.of(context).pop();
                      String? user_id = await Provider.of<DataController>(context, listen: false).getCareProviderAccountByEmail(widget.careProviderSlots["email"]);
                      CarProviderSlot slot = CarProviderSlot(
                        status: "new",
                        serviceID: selectedService!.id??"",
                        serviceName: selectedService!.name??"",
                        careProviderId: user_id,
                        careProviderName: carProviderData?.hotelName??"",
                        date: "${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year}",
                        fromTime: "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                        slotPrice: int.parse(price!), // Include the price

                        // petOwnerId: ""
                      );

                      await Provider.of<UserController>(context, listen: false).addCareProviderSlot(slot);
                      CoolAlert.show(context: context, type: CoolAlertType.success ,width: 400, title: "" ,
                          text: "Slot added successfully",
                          closeOnConfirmBtnTap: false,
                          onConfirmBtnTap: (){
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pop(true);
                            getData();
                          }
                      );
                    }
                   else {
                      CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Select date, time and service");

                    }

                  },
                  child: Text('Confirm', style: textStyle(fontWeight: FontWeight.w500 , color: MyStyle.mainColor),),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
