import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' ;
import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/widgetController.dart';
import '../../model/petCareModel.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateCarProviderProfile extends StatefulWidget {
  const UpdateCarProviderProfile({super.key ,required this.carProviderData});
  final PetCareProfile carProviderData ;
  @override
  State<UpdateCarProviderProfile> createState() => _UpdateCarProviderProfileState();
}

class _UpdateCarProviderProfileState extends State<UpdateCarProviderProfile> {

  TextEditingController hotelNameController = TextEditingController();
  TextEditingController profileDescription = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController hotelPlaceController = TextEditingController();
  File? profileImage;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hotelNameController = TextEditingController(text: widget.carProviderData.hotelName??"");
    profileDescription = TextEditingController(text: widget.carProviderData.profileDescription??"");
    phoneController = TextEditingController(text: widget.carProviderData.mobile??"");
    hotelPlaceController = TextEditingController(text: widget.carProviderData.hotelPlace??"");
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


                  // Hotel Name
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      child: Text("Care Provider Name", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  InputTextWidget("", hotelNameController),
                  const SizedBox(height: 16),


                    // Profile Description
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      child: Text("Profile Description", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  InputTextWidget("", profileDescription),
                  const SizedBox(height: 16),




                  // Phone Number
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),child: Text("Phone Number", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  InputTextWidget("", phoneController),
                  const SizedBox(height: 16),


                  // Hotel Place
                  Container(
                      padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),child: Text("Shelter Place", style: textStyle(fontSize: 15))),
                  const SizedBox(height: 5),
                  InputTextWidget(
                      "" , hotelPlaceController
                  ),
                  const SizedBox(height: 20),



                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 350,
                      child: MaterialButton(
                          onPressed: () async {
                            if(hotelNameController.text.isEmpty) {
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.error,
                                  width: 400,
                                  title: "Please add the hotel name");
                              return;
                            } else  if(hotelPlaceController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Please enter the hotel place");
                            }  else  if(profileDescription.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Please enter the profile description");
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
    Map<String, dynamic> carProviderData = {
      if(downloadUrl != null)"profile_image" : downloadUrl,
      "hotel_name" : hotelNameController.text,
      "hotel_place" : hotelPlaceController.text,
      "mobile" : phoneController.text,
      "profile_description" : profileDescription.text,
    };

    String? user_id = await Provider.of<DataController>(context, listen: false).getCareProviderAccountByEmail(widget.carProviderData.email??"");
    if(user_id != null){
      await Provider.of<DataController>(context, listen: false).updateCareProviderProfile(
        user_id: user_id,
        carProviderData: carProviderData
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
