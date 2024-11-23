import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pethotel/controller/styleController.dart';
import 'package:pethotel/controller/userController.dart';
import 'package:provider/provider.dart';

import '../../controller/dataController.dart';
import '../../controller/widgetController.dart';
import '../../model/petCareModel.dart';
import '../../model/petOwnerModel.dart';
import '../../model/servicesFireBaseModel.dart';

class PetOwnerProfileData extends StatefulWidget {
  const PetOwnerProfileData({super.key });
  // final Map<String, dynamic> petOwnerData ;
  @override
  State<PetOwnerProfileData> createState() => _PetOwnerProfileDataState();
}

class _PetOwnerProfileDataState extends State<PetOwnerProfileData> {
  PetOwnerProfile? petOwnerData ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      await updateData();
    });

  }

  Future<void> updateData() async {
    showLoadingDialog(context);

    String? user_id = FirebaseAuth.instance.currentUser?.uid;
    if (user_id != null) {
      await Provider.of<UserController>(context, listen: false).getPetOwnerProfile(user_id ?? "");
      petOwnerData = Provider.of<UserController>(context, listen: false).userPetOwnerProfile;
      Navigator.of(context).pop();
      // earnings

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.only(top :8.0 , bottom: 8 , right: 15 , left: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 150,
                    height: 150,
                  ),
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
                        petOwnerData?.profileImage ?? "", width: 150,
                        height: 150,
                        errorBuilder: (BuildContext? context, Object? exception,
                            StackTrace? stackTrace) {
                          return Image.network(
                              "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                              width: 150, height: 150);
                        },),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: InkWell(
                      onTap: (){
                        print("petOwnerData ${petOwnerData!.toJson()}");
                        log("petOwnerData ${petOwnerData!.toJson()}");
                        Navigator.pushNamed(context, '/UpdatePetOwnerProfilePage' , arguments: petOwnerData,).then((value) async {
                          print("00__$value");
                          if(value != null){
                            await updateData();
                          }

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.edit , color:MyStyle.mainColor,),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10,),

              customCard("${petOwnerData?.firstName ?? ""} ${petOwnerData?.lastName ?? ""}" ?? " - " , "Full Name"),
              customCard(petOwnerData?.email ?? " - ","Email"),
              customCard(petOwnerData?.petWeight ?? " - ","Pet Weight"),
              customCard(petOwnerData?.petType ?? " - ","Pet Type"),
              customCard(petOwnerData?.petHeight ?? " - ","Pet Height"),
              customCard(petOwnerData?.petAge ?? " - ","Pet Age"),

              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }


}
