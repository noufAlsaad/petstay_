import 'package:flutter/material.dart';
// 
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
import '../../model/petVeterinarianModel.dart';
import '../../model/servicesFireBaseModel.dart';

class VeterinarianProfilePage extends StatefulWidget {
  const VeterinarianProfilePage({super.key });
  @override
  State<VeterinarianProfilePage> createState() => _VeterinarianProfilePageState();
}

class _VeterinarianProfilePageState extends State<VeterinarianProfilePage> {
  PetVeterinarian? petVeterinarian ;

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

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      await Provider.of<UserController>(context, listen: false).getVeterinarianProfile(FirebaseAuth.instance.currentUser?.uid ?? "");
      petVeterinarian = Provider.of<UserController>(context, listen: false).petVeterinarian;
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
                        petVeterinarian?.profileImage ?? "", width: 150,
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

                        Navigator.pushNamed(context, '/UpdateVeterinarianProfile' , arguments: petVeterinarian,).then((value) async {
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

              // customCard(petVeterinarian?.profileDescription ?? " - " , "Profile Description"),
              customCard(petVeterinarian?.firstName ?? " - " , "First Name"),
              customCard(petVeterinarian?.lastName ?? " - ","Last Place"),
              customCard(petVeterinarian?.birthdate ?? " - ","Birth Date"),
              customCard(petVeterinarian?.email ?? " - ","Email"),
              customCard(petVeterinarian?.mobile ?? " - ","Mobile"),
              customCard(petVeterinarian?.gender ?? " - ","Gender"),
              customCard(petVeterinarian?.address ?? " - ","Address"),
              customCard(petVeterinarian?.medicalHistory ?? " - ","Medical History"),
              customCard(petVeterinarian?.certificate ?? " - ","Certificate"),
              customCard(petVeterinarian?.licenseNumber ?? " - ","License Number"),


              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }



}
