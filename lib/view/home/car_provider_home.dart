import 'package:flutter/material.dart';
import 'package:pethotel/controller/styleController.dart';
import 'package:pethotel/controller/widgetController.dart';

import '../../model/petCareModel.dart';
import '../car_providers/car_provider_profile.dart';
import '../car_providers/car_provider_schedule.dart';

class CarProviderHome extends StatefulWidget {
  @override
  State<CarProviderHome> createState() => _CarProviderHomeState();
}

class _CarProviderHomeState extends State<CarProviderHome> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;



    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: MyStyle.white),
          leading: SizedBox(),
          backgroundColor: MyStyle.mainColor,
          title: Text('Home Page' , style: textStyle(fontSize: 16 , color: MyStyle.white),),
          bottom: TabBar(

            tabs: [
              Tab(child: Text('Slots' ,  style: textStyle(fontSize: 14 , color: MyStyle.white)),),
              Tab(child: Text('Profile' ,  style: textStyle(fontSize: 14 , color: MyStyle.white)),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CarProviderSchedule(careProviderSlots: args), // Replace with your Slots Page widget
            CarProviderProfile(carProviderData: args), // Replace with your Profile Page widget
          ],
        ),
      ),
    );
  }
}
