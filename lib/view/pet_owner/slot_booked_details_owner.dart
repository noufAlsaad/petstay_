import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pethotel/controller/paymentController.dart';
import 'package:provider/provider.dart';

import '../../controller/chatController.dart';
import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/userController.dart';
import '../../controller/widgetController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/chatRoomModel.dart';
import '../../model/messagesModel.dart';
import '../../model/petCareModel.dart';
import '../../model/petOwnerModel.dart';
import '../../model/servicesFireBaseModel.dart';
import '../car_providers/slot_details.dart';

class SlotBookedDetailsOwnerPage extends StatefulWidget {
  const SlotBookedDetailsOwnerPage({super.key , required this.slot});
  final CarProviderSlot slot ;
  @override
  State<SlotBookedDetailsOwnerPage> createState() => _SlotBookedDetailsOwnerPageState();
}

class _SlotBookedDetailsOwnerPageState extends State<SlotBookedDetailsOwnerPage> {

  PetCareProfile? carProviderData ;
  PetOwnerProfile? petOwnerProfile ;
  Map<String, dynamic>? ratingData ;
  int? rating ;
  List<Services> hisServicesList  = [] ;
  TextEditingController? _controller;
  Stream<List<MessageModel>>? _stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      await getData();

    });

  }


  Future<void> getData() async {
    showLoadingDialog(context);
    if (widget.slot.careProviderId != null) {
      carProviderData = await Provider.of<UserController>(context, listen: false).getCareProviderProfileForOwner(widget.slot.careProviderId ?? "");
      await Provider.of<UserController>(context, listen: false).getPetOwnerProfile(FirebaseAuth.instance.currentUser?.uid ?? "");
      ratingData = await Provider.of<UserController>(context, listen: false).getRatingBySlot(widget.slot);
      petOwnerProfile = Provider.of<UserController>(context, listen: false).userPetOwnerProfile;
      hisServicesList.clear();
      await Provider.of<DataController>(context, listen: false).fetchCareProviderServicesFromFirestore(hisServicesList , mine: true , userID: widget.slot.careProviderId??"");

      // FcihstfykxNaUJ0E7Rod1frwfx92-6JTyYPRwQLSaHrgzd9dHmFrydaq1-JrLvs3qsPg1pgPyGv6Yx


      // FcihstfykxNaUJ0E7Rod1frwfx92-MBmTFPwOSIcUVEBUxrlEeUm6T6I3-JrLvs3qsPg1pgPyGv6Yx

      String? user_id = await Provider.of<DataController>(context, listen: false).getPetOwnerAccountByEmail(widget.slot.petOwnerEmail??"");
      petOwnerProfile = await Provider.of<DataController>(context, listen: false).getPetOwnerProfile(user_id??"");
      _controller = TextEditingController();
      print("'${widget.slot.petOwnerId}-${widget.slot.careProviderId}-${widget.slot.slotID}' ddddd");
      _stream = ChatController().messagesStream(roomId: '${widget.slot.petOwnerId}-${widget.slot.careProviderId}-${widget.slot.slotID}');
      setState(() {});
    }
    setState(() {});
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyStyle.white),
        // leading: SizedBox(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Image.asset(
              "assets/images/logo.png",
              scale: 2,
              color: MyStyle.white,
            ),
          ),
        ],
        backgroundColor: MyStyle.mainColor,
        title: Text('Slot Details' , style: textStyle(fontSize: 16 , color: MyStyle.white),),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  customCard(widget.slot.date?? " - " , "Slot Date"),
                  customCard(widget.slot.fromTime?? " - " , "From Time"),
                  customCard(widget.slot.status?? " - " , "Status"),
                  if(ratingData != null)customCard("${ratingData!["rating"]?? " - " }", "Your Rating"),
                  customCard(widget.slot.serviceName?? " - " , "Service Name"),
                  customCard("${widget.slot.slotPrice?? "0 "} SAR" , "Slot Price"),

                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: MyStyle.mainColor!, width: 2.0),
                              // Border color and width
                              borderRadius: BorderRadius.circular(
                                  25.0), // Border radius to match ClipRRect
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Image.network(
                                carProviderData?.profileImage ?? "", width: 50,
                                height: 50,
                                errorBuilder: (BuildContext? context, Object? exception,
                                    StackTrace? stackTrace) {
                                  return Image.network(
                                      "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                                      width: 50, height: 50);
                                },),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      Expanded(child: customCard(carProviderData?.hotelName ?? " - " , "Care Provider Name")),
                    ],
                  ),
                  customCard(carProviderData?.hotelPlace ?? " - ","Shelter Place"),
                  customCard(carProviderData?.profileDescription ?? " - " , "Profile Description"),

                  Row(
                    children: [
                      Expanded(child: customCard(hisServicesList.isEmpty ? " - "  :   hisServicesList
                          .map((service) => service.name)
                          .where((name) => name != null) // Filter out null names
                          .join(', '),"Service")),
                      // Expanded(child: customCard(myServicesListBase.join(', ') ?? " - ","My Service")),
                    ],
                  ),
                  customCard("${rating ?? " - " }"  , "Rating"),

                  customCard(carProviderData?.email ?? " - ","Email"),
                  customCard(carProviderData?.mobile ?? " - ","Mobile"),

                  SizedBox(height: 20,),

                  if(widget.slot.status!.toLowerCase() == "completed" && ratingData == null)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 400,
                        child: MaterialButton(
                            onPressed: () async {
                              double rating = 2.5;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Rate the care provider" , style: textStyle(),),
                                            SizedBox(height: 20,),
                                            PannableRatingBar(
                                              rate: rating,
                                              items: List.generate(5, (index) =>
                                              const RatingWidget(
                                                selectedColor: Colors.yellow,
                                                unSelectedColor: Colors.grey,
                                                child: Icon(
                                                  Icons.star,
                                                  size: 48,
                                                ),
                                              )),
                                              onChanged: (value) { // the rating value is updated on tap or drag.
                                                setState(() {
                                                  rating = value;
                                                });
                                              },
                                            ),
                                            SizedBox(height: 20,),
                                            Row(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: MaterialButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).pop();
                                                      },
                                                      color: MyStyle.mainColor,
                                                      elevation: 4,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0)),
                                                      padding: const EdgeInsets.all(0.0),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text(
                                                            "Cancel",
                                                            style: textStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(width: 100,),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: MaterialButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).pop(true);
                                                      },
                                                      color: MyStyle.mainColor,
                                                      elevation: 4,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0)),
                                                      padding: const EdgeInsets.all(0.0),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text(
                                                            "Rate",
                                                            style: textStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  );
                                },
                              ).then((value) {
                                if(value != null){
                                  CoolAlert.show(context: context, type: CoolAlertType.success ,width: 400, title: "Thanks for rating" ,
                                      onConfirmBtnTap: () async {
                                        await Provider.of<UserController>(context, listen: false).addPetCareProviderRate(widget.slot , rating );
                                        Navigator.of(context).pop(true);
                                      });
                                }
                              });


                            },
                            color: MyStyle.mainColor,
                            elevation: 4,
                            // color: Theme_Information.Button_Color,
                            // color: MyStyle.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Rate This Slot",
                                  style: textStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ),
                    ),

                  if(widget.slot.status!.toLowerCase() == "booked")
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 400,
                        child: MaterialButton(
                            onPressed: () async {

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PaymentPage(price: widget.slot.slotPrice??0,);
                                },
                              ).then((value) {
                                if(value != null){
                                  CoolAlert.show(context: context, type: CoolAlertType.success ,width: 400, title: "Thanks for pay" ,
                                      onConfirmBtnTap: () async {
                                        await Provider.of<UserController>(context, listen: false).completeSlot(widget.slot);
                                        Navigator.of(context).pop(true);
                                      });
                                }
                              });
                            },
                            color: MyStyle.mainColor,
                            elevation: 4,
                            // color: Theme_Information.Button_Color,
                            // color: MyStyle.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Pay And Complete Booking",
                                  style: textStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ),
                    ),


                  const SizedBox(
                    height: (10),
                  ),


                ],
              ),
            ),
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Chat with the pet care provider" , style: textStyle(fontSize: 16 , fontWeight: FontWeight.w500),),
                  )),
                  ///
                  Expanded(
                    child: StreamBuilder<List<MessageModel>>(
                      stream: _stream,
                      builder: (c, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.amber,
                            ),
                          );
                        }

                        List<MessageModel> messages = snap.data??[];

                        if (messages != null) {
                          return Container(
                            height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top) * .55,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (c, i) {
                                return messages[i].idForLastUser == FirebaseAuth.instance.currentUser!.uid
                                    ? MyMessageWidget(
                                  message: messages[i],
                                  myName: "Me",
                                )
                                    : OtherIdMessageWidget(
                                  message: messages[i],
                                  seniorName: "${petOwnerProfile?.firstName} ${petOwnerProfile?.lastName}",
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                try {
                                  if (DateFormat.yMMMd()
                                      .format(messages[index].dateTime!) !=
                                      DateFormat.yMMMd()
                                          .format(messages[index - 1].dateTime!)) {
                                    return buildContainerDate(messages, index);
                                  } else {
                                    return SizedBox();
                                  }
                                } catch (e) {
                                  print("eee $e");
                                  if (e
                                      .toString()
                                      .contains("Not in inclusive range 0..1: -1")) {
                                    return buildContainerDate(messages, index);
                                  }
                                  return SizedBox();
                                }
                              },
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onFieldSubmitted: (value){
                            sendMsg();
                          },
                          style: textStyle(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: MyStyle.mainColor!, width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:  BorderSide(
                                    color: MyStyle.mainColor!, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:  BorderSide(
                                    color: MyStyle.mainColor!, width: 1.5),
                              ),
                              filled: true,

                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                      Icons.send,
                                      color: MyStyle.mainColor!
                                  ),
                                  onPressed: () {
                                    sendMsg();
                                  })),
                          controller: _controller,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  )
                  ///
                ],
              ),
            ),
          )

        ],
      ),
    );
  }


  // FcihstfykxNaUJ0E7Rod1frwfx92-MBmTFPwOSIcUVEBUxrlEeUm6T6I3-JrLvs3qsPg1pgPyGv6Yx
  // FcihstfykxNaUJ0E7Rod1frwfx92-6JTyYPRwQLSaHrgzd9dHmFrydaq1-JrLvs3qsPg1pgPyGv6Yx
  // FcihstfykxNaUJ0E7Rod1frwfx92-6JTyYPRwQLSaHrgzd9dHmFrydaq1-JrLvs3qsPg1pgPyGv6Yx


  // FcihstfykxNaUJ0E7Rod1frwfx92-MBmTFPwOSIcUVEBUxrlEeUm6T6I3-JrLvs3qsPg1pgPyGv6Yx
  void sendMsg() {
    print('${widget.slot.petOwnerId}-${widget.slot.careProviderId}-${widget.slot.slotID}');
    if (_controller!.text.isNotEmpty) {
      ChatController().insertMessageNormalChatPetOwner(
        message: MessageModel(
          message: _controller!.text,
          petOwnerId: widget.slot.petOwnerId,
          petCareUserId: widget.slot.careProviderId,
          hotelName: "Me",
          petOwnerName: "${petOwnerProfile?.firstName} ${petOwnerProfile?.lastName}" ,
        ),
        roomId: '${widget.slot.petOwnerId}-${widget.slot.careProviderId}-${widget.slot.slotID}',
      );

    } else {}
    _controller!.clear();
  }

  Container buildContainerDate(List<MessageModel> messages, int index) {
    return Container(
      child: Center(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Text(DateFormat.yMMMd().format(messages[index].dateTime!),
                    style: textStyle(
                      color: Colors.black,
                      fontSize: 15,
                    )),
              ))),
    );
  }


}
