import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/chatController.dart';
import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/userController.dart';
import '../../controller/widgetController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/chatRoomModel.dart';
import '../../model/petCareModel.dart';
import '../../model/petOwnerModel.dart';
import '../../model/servicesFireBaseModel.dart';

class SlotDetailsOwnerPage extends StatefulWidget {
  const SlotDetailsOwnerPage({super.key , required this.slot});
  final CarProviderSlot slot ;
  @override
  State<SlotDetailsOwnerPage> createState() => _SlotDetailsOwnerPageState();
}

class _SlotDetailsOwnerPageState extends State<SlotDetailsOwnerPage> {

  PetCareProfile? carProviderData ;
  PetOwnerProfile? petOwnerProfile ;
  int? rating ;
  List<Services> hisServicesList  = [] ;


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
      petOwnerProfile = Provider.of<UserController>(context, listen: false).userPetOwnerProfile;
      hisServicesList.clear();
      await Provider.of<DataController>(context, listen: false).fetchCareProviderServicesFromFirestore(hisServicesList , mine: true, userID: widget.slot.careProviderId??"");
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
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    customCard(widget.slot.date?? " - " , "Slot Date"),
                    customCard(widget.slot.fromTime?? " - " , "From Time"),
                    customCard(widget.slot.status?? " - " , "Status"),
                    customCard(widget.slot.serviceName?? " - " , "Service Name"),
                    customCard("${widget.slot.slotPrice?? "0 "} SAR" , "Slot Price"),
                    const SizedBox(
                      height: (10),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 400,
                        child: MaterialButton(
                            onPressed: () async {
                              if(petOwnerProfile != null && widget.slot.slotID != null){
                                CoolAlert.show(
                                    width: 500,
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    title: "Book Slot",
                                    text: "Are you sure you want to book slot in ${widget.slot.date} at ${widget.slot.fromTime}?",
                                    onConfirmBtnTap: () async {
                                      print("book slot");
                                      showAboutDialog(context: context);
                                      await Provider.of<UserController>(context, listen: false).bookSlot(petOwnerProfile! , widget.slot.slotID!);
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacementNamed(context, '/PetOwnerHome');
                                    }
                                );
                              } else {
                                CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Please try again");
                              }

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
                                  "Book This Slot",
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
              child: SingleChildScrollView(
                child: Column(
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
                              carProviderData?.profileImage ?? "", width: 150,
                              height: 150,
                              errorBuilder: (BuildContext? context, Object? exception,
                                  StackTrace? stackTrace) {
                                return Image.network(
                                    "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                                    width: 150, height: 150);
                              },),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    customCard(carProviderData?.hotelName ?? " - " , "Care Provider Name"),
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

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
