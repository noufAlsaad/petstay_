import 'package:flutter/material.dart';
// 
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pethotel/view/Veterinarians/pending_sessions.dart';
import 'package:pethotel/view/Veterinarians/veterinarian_profile.dart';
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
import 'history_sessions.dart';

class VeterinarianHomePage extends StatefulWidget {
  const VeterinarianHomePage({super.key });
  @override
  State<VeterinarianHomePage> createState() => _VeterinarianHomePageState();
}

class _VeterinarianHomePageState extends State<VeterinarianHomePage> {
  int screenIndex = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      // await getServices();
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    screens = [
      PendingSessionsPage(),
      HistorySessionsPage(),
      VeterinarianProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyStyle.white),
        // leading: SizedBox(),
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
                  title: "Pending Session", icon: Icons.calendar_month, index: 0, onTap: () {
                setState(() {
                  screenIndex = 0;
                });
              }, screenIndex: screenIndex),
              buildRow(title:  "History Session",
                  icon: Icons.history,
                  index: 1,
                  onTap: () {
                    setState(() {
                      screenIndex = 1;
                    });
                  } ,screenIndex: screenIndex),
              buildRow(title:  "Profile Page",
                  icon: Icons.account_circle,
                  index: 2,
                  onTap: () {
                    setState(() {
                      screenIndex = 2;
                    });
                  } ,screenIndex: screenIndex),
            ],
          ),
        ),
      ),
      body: screens[screenIndex],
    );
  }

  String dataTitle() {
    if (screenIndex == 0) {
      return 'Pending Session';
    } else if (screenIndex == 1) {
      return 'History Session';
    }else if (screenIndex == 2) {
      return 'Profile Page';
    }
    return "";
  }




}
