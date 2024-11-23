import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/chatController.dart';
import '../../controller/dataController.dart';
import '../../controller/userController.dart';
import '../../controller/widgetController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/chatRoomModel.dart';
import '../../model/messagesModel.dart';
import '../../model/petOwnerModel.dart';

class OwnerBookingPage extends StatefulWidget {
  const OwnerBookingPage({super.key});

  @override
  State<OwnerBookingPage> createState() => _OwnerBookingPageState();
}

class _OwnerBookingPageState extends State<OwnerBookingPage> {
  List<CarProviderSlot>? items ;
  PetOwnerProfile? petOwnerProfile ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // OwnerBookingPage
    Future.delayed(const Duration(microseconds: 3), () async {
      await getData();
    });



  }

  Future<void> getData() async {
    showLoadingDialog(context);
    items = await Provider.of<UserController>(context, listen: false).getOwnerBooking(FirebaseAuth.instance.currentUser?.uid ?? "") ?? [];
    petOwnerProfile = await Provider.of<DataController>(context, listen: false).getPetOwnerProfile(FirebaseAuth.instance.currentUser?.uid??"");
    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: items == null ? SizedBox() : Column(
          children: List.generate(items!.length, (index) {
            final item = items![index] ;

            return Card(
              child: ListTile(
                onTap: () async {
                  final chatRoom = ChatRoomModel(
                    petOwnerId: FirebaseAuth.instance.currentUser!.uid,
                    petOwnerName: "${petOwnerProfile?.firstName??""} ${petOwnerProfile?.lastName??""}",
                    isPetCare: true,
                    hotelName: item?.careProviderName ?? " - ",
                    petCareUserId:  item.careProviderId,
                    message: MessageModel(
                      message: '',
                    ),
                  );
                  ///
                  await ChatController().createChatRoom(chatRoom: chatRoom ,slotID: item.slotID??"");

                  Navigator.pushNamed(
                      context, '/SlotBookedDetailsOwnerPage',
                      arguments: item).then((value) async {

                        if(value != null){
                          await getData();
                          setState(() {});
                        }
                  });
                },
                title: Text(
                  "Slot on: ${item.date} With ${item.careProviderName?? " - "}",
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
        ),
      ),
    );
  }
}
