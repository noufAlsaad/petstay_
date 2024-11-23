import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pethotel/view/pet_owner/pet_owner_profile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/userController.dart';
import '../../controller/widgetController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/petOwnerModel.dart';
import '../../model/servicesFireBaseModel.dart';
import 'notification_pet_owner_page.dart';
import 'owner_booking_page.dart';

class PetOwnerHome extends StatefulWidget {
  const PetOwnerHome({super.key});

  @override
  State<PetOwnerHome> createState() => _PetOwnerHomeState();
}

class _PetOwnerHomeState extends State<PetOwnerHome> {
  int screenIndex = 0;

  List<Widget> screens = [];
  List<Services> servicesList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      await getServices();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    screens = [
      home(),
      OwnerBookingPage(),
      NotificationPetOwnerPage(),
      PetOwnerProfileData(),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyStyle.white),
        leading: SizedBox(),
        backgroundColor: MyStyle.mainColor,
        title: Text(
          dataTitle(), style: textStyle(fontSize: 16, color: MyStyle.white),),
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
      ),
      bottomNavigationBar: Container(
        color: MyStyle.mainColor,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildRow(
                  title: "Home Page", icon: Icons.home, index: 0, onTap: () {
                setState(() {
                  screenIndex = 0;
                });
              } ,screenIndex: screenIndex),
              buildRow(title: "Booking History",
                  icon: Icons.history,
                  index: 1,
                  onTap: () {
                    setState(() {
                      screenIndex = 1;
                    });
                  } ,screenIndex: screenIndex),
              buildRow(title: "Notifications",
                  icon: Icons.notifications,
                  index: 2,
                  onTap: () {
                    setState(() {
                      screenIndex = 2;
                    });
                  },screenIndex: screenIndex),
              buildRow(title: "Profile",
                  icon: Icons.account_circle,
                  index: 3,
                  onTap: () {
                    setState(() {
                      screenIndex = 3;
                    });
                  },screenIndex: screenIndex),
            ],
          ),
        ),
      ),
      body: screens[screenIndex],
    );
  }

  String dataTitle() {
    if (screenIndex == 0) {
      return 'Home Page';
    } else if (screenIndex == 1) {
      return 'Booking History';
    } else if (screenIndex == 2) {
      return 'Notifications';
    } else if (screenIndex == 3) {
      return 'Profile';
    }

    return "";
  }



  Widget home() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),

        /// slider
        Builder(
            builder: (context) {
              return CarouselSlider(
                options: CarouselOptions(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.4),
                items: [
                  "assets/images/pethotel6.JPG",
                  "assets/images/pethotel10.JPG",
                  "assets/images/pethotel7.JPG",
                  "assets/images/pethotel5.jpeg",
                ].map((i) {
                  return Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: MyStyle.mainColor
                      ),
                      child: Center(child: Image.asset(
                          '$i', fit: BoxFit.fill, width: MediaQuery
                          .of(context)
                          .size
                          .width))
                  );
                }).toList(),
              );
            }
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Services", style: textStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),),
                  Center(
                    child: Wrap(
                      children: List.generate(servicesList.length, (index) {
                        final item = servicesList[index];
                        return InkWell(
                          onTap: () async {
                            // service_details

                            if(item.id.toString() == "-1"){
                              /// Veterinarian
                              Navigator.pushNamed(
                                  context, '/SessionPage');
                            }
                            else {
                              showLoadingDialog(context);
                              List<CarProviderSlot> items = await Provider.of<UserController>(context, listen: false).getSlotsDependOnService(item.id ?? "") ?? [];
                              DateTime now = DateTime.now();
                              List<CarProviderSlot> filteredSlots = items.where((slot) {
                                if (slot.status != 'new') return false;
                                DateTime slotDate = DateFormat('dd-MM-yyyy').parse(slot.date??"");
                                TimeOfDay timeOfDay = TimeOfDay(
                                  hour: int.parse(slot.fromTime!.split(':')[0]),
                                  minute: int.parse(slot.fromTime!.split(':')[1]),
                                );
                                // Combine date and time
                                DateTime combinedDateTime = DateTime(
                                  slotDate.year,
                                  slotDate.month,
                                  slotDate.day,
                                  timeOfDay.hour,
                                  timeOfDay.minute,
                                );
                                print("combinedDateTime ${combinedDateTime}");
                                return  combinedDateTime.isAfter(now);
                                // return combinedDateTime.isAtSameMomentAs(now) || combinedDateTime.isAfter(now);
                              }).toList();


                              Navigator.pop(context);
                              if(filteredSlots.isNotEmpty){
                                Navigator.pushNamed(
                                    context, '/AllSlotPageOwner',
                                    arguments: filteredSlots);
                              } else {
                                CoolAlert.show(
                                  width: 400,
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "Error!",
                                  text: "There is no slots in this service",
                                );
                              }
                            }
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                child: Row(
                                  children: [
                                    Image.network(
                                      item.image ?? "", height: 50, width: 50,),
                                    SizedBox(width: 10,),
                                    Text(item.name ?? "", style: textStyle(),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  )

                ],
              ),
            ),
          ),
        )

      ],
    );
  }

  Future<void> getServices() async {
    showLoadingDialog(context);


    servicesList.clear();
    await Provider.of<DataController>(context, listen: false)
        .fetchCareProviderServicesFromFirestore(servicesList);
    servicesList.add(Services(
        id: "-1",
        name: "Veterinarian",
        image: "https://cdn-icons-png.freepik.com/512/2934/2934734.png"
    ));
    Navigator.pop(context);

  }



}
