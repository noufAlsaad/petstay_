import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' ;
import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/widgetController.dart';
import '../../model/petCareModel.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../model/petOwnerModel.dart';

class UpdatePetOwnerProfilePage extends StatefulWidget {
  const UpdatePetOwnerProfilePage({super.key ,required this.petOwnerProfile});
  final PetOwnerProfile petOwnerProfile ;
  @override
  State<UpdatePetOwnerProfilePage> createState() => _UpdatePetOwnerProfilePageState();
}

class _UpdatePetOwnerProfilePageState extends State<UpdatePetOwnerProfilePage> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  TextEditingController petWightController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController petHeightController = TextEditingController();
  TextEditingController petTypeController = TextEditingController();

  File? profileImage;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<String> petTypes = ['Dog', 'Cat', 'Bird', 'Fish', 'Reptile'];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameController = TextEditingController(text: widget.petOwnerProfile.firstName??"");
    lastNameController = TextEditingController(text: widget.petOwnerProfile.lastName??"");
    // emailController = TextEditingController(text: widget.petOwnerProfile.email??"");
    petAgeController = TextEditingController(text: widget.petOwnerProfile.petAge??"");
    petHeightController = TextEditingController(text: widget.petOwnerProfile.petHeight??"");
    petTypeController = TextEditingController(text: widget.petOwnerProfile.petType??"");
    petWightController = TextEditingController(text: widget.petOwnerProfile.petWeight??"");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  Text("Update Profile", style: textStyle(fontSize: 18 ,color: MyStyle.mainColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (profileImage != null)
                        Image.network(
                          Url.createObjectUrl(profileImage!),
                          height: 200,
                        ),
                      if (profileImage == null)
                        SizedBox(width: 10),
                      if (profileImage == null)
                        InkWell(
                          onTap: (){
                            _selectImage();
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Image.network(
                                  "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                                  height: 100,
                                ),
                              ),
                              Positioned.fill(child: Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.add),
                              )),

                            ],
                          ),
                        ),

                    ],
                  ),
                  const SizedBox(
                    height: (10),
                  ),


                  // first Name
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      child: Text("First Name", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  InputTextWidget("", firstNameController),
                  const SizedBox(height: 16),

                  // last Name
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      child: Text("Last Name", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  InputTextWidget("", lastNameController),
                  const SizedBox(height: 16),

                  /// Email
                  // Container(
                  //     padding:  EdgeInsets.only(right: 25, left: 25) , margin: const EdgeInsets.only(
                  //     left: 20, right: 20, top: 0, bottom: 0),child: Text("Email", style: textStyle(fontSize: 15))),
                  // const SizedBox(height: 5),
                  // InputTextWidget("", emailController),
                  // const SizedBox(height: 16),



                  // Pet Type
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),child: Text("Pet Type", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  // InputTextWidget(
                  //     "" , petTypeController
                  // ),

                  InputDropdownWidget(
                    "",
                    petTypeController,
                    petTypes,
                  ),
                  const SizedBox(height: 20),




                  // Pet Age
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),child: Text("Pet Age", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  // InputTextWidget(
                  //     "" , petAgeController
                  // ),
                  AgeDropdownWidget(
                    textEditingController: petAgeController,
                  ),


                  const SizedBox(height: 20),


                  // Pet wight
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),child: Text("Pet Weight", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  // InputTextWidget(
                  //     "" , petWightController
                  // ),

                  WeightDropdownWidget(
                    weightController: petWightController,
                  ),

                  const SizedBox(height: 20),


                  // Pet height
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),child: Text("Pet height", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  // InputTextWidget(
                  //     "" , petHeightController
                  // ),

                  HeightDropdownWidget(
                    heightController: petHeightController,
                  ),

                  const SizedBox(height: 20),



                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 350,
                      child: MaterialButton(
                          onPressed: () async {
                            if(firstNameController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Please add the full name");
                              return ;
                            }  else if(lastNameController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Please add the full name");
                              return ;
                            }
                            else  if(petWightController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Please enter the pet wight");
                            }
                            else  if(petTypeController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Please enter the pet type");
                            }
                            else  if(petAgeController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Please enter the pet age");
                            }
                            else  if(petHeightController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Please enter the pet height");
                            }
                            // else if (profileImage == null) {
                            //   CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Please add your profile image");
                            // }
                            else {
                              CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading);
                              if(profileImage != null){
                                _uploadImage();
                              } else {
                                await updateData();
                              }

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
                                "Update Account",
                                style: textStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                    ),
                  ),



                  const SizedBox(height: 70),


                ],
              ),
            ),
          ),
        ),
    );
  }


  Future<void> _selectImage() async {
    final completer = Completer<File>();
    final input = FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files!;
      if (files.isNotEmpty) {
        completer.complete(files[0]);
      }
    });

    profileImage = await completer.future;
    setState(() {});
  }

  Future<void> _uploadImage() async {
    if (profileImage == null) return;

    final fileName = profileImage!.name;
    final destination = 'car_provider_profile_images/$fileName';

    final ref = _storage.ref(destination);
    await ref.putBlob(profileImage!);

    final downloadUrl = await ref.getDownloadURL();
    print("downloadUrl ${downloadUrl}");

    await updateData(downloadUrl: downloadUrl);
  }

  Future<void> updateData({String? downloadUrl}) async {
    Map<String, dynamic> data = {
      if(downloadUrl != null)"profile_image" : downloadUrl,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "pet_type": petTypeController.text,
      "pet_wight": petWightController.text,
      "pet_age": petAgeController.text,
      "pet_height": petHeightController.text,
    };




    String? user_id = FirebaseAuth.instance.currentUser?.uid;
    if(user_id != null){
      await Provider.of<DataController>(context, listen: false).updatePetOwnerProfile(
        user_id: user_id,
        petOwnerData: data
      );
      CoolAlert.show(context: context, type: CoolAlertType.success ,width: 400, title: "Your account updated successfully" ,
          closeOnConfirmBtnTap: false,
          onConfirmBtnTap: (){
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          }
      );
    }
  }

}
