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

import '../../model/petVeterinarianModel.dart';

class UpdateVeterinarianProfile extends StatefulWidget {
  const UpdateVeterinarianProfile({super.key ,required this.veterinarianData});
  final PetVeterinarian veterinarianData ;


  @override
  State<UpdateVeterinarianProfile> createState() => _UpdateVeterinarianProfileState();
}

class _UpdateVeterinarianProfileState extends State<UpdateVeterinarianProfile> {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController workplaceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController medicalHistoryController = TextEditingController();
  final TextEditingController certificateController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  File? profileImage;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing data
    firstNameController.text = widget.veterinarianData.firstName ?? "";
    lastNameController.text = widget.veterinarianData.lastName ?? "";
    mobileController.text = widget.veterinarianData.mobile ?? "";
    birthdateController.text = widget.veterinarianData.birthdate ?? "";
    emailController.text = widget.veterinarianData.email ?? "";
    workplaceController.text = widget.veterinarianData.workplace ?? "";
    addressController.text = widget.veterinarianData.address ?? "";
    medicalHistoryController.text = widget.veterinarianData.medicalHistory ?? "";
    certificateController.text = widget.veterinarianData.certificate ?? "";
    licenseNumberController.text = widget.veterinarianData.licenseNumber ?? "";
    genderController.text = widget.veterinarianData.gender ?? "";
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


                  _buildTextField("First Name", firstNameController),
                  const SizedBox(height: 16),
                  _buildTextField("Last Name", lastNameController),
                  const SizedBox(height: 16),
                  _buildTextField("Mobile", mobileController),
                  const SizedBox(height: 16),
                  _buildTextField("Birthdate", birthdateController),
                  const SizedBox(height: 16),
                  _buildTextField("Email", emailController),
                  const SizedBox(height: 16),
                  _buildTextField("Workplace", workplaceController),
                  const SizedBox(height: 16),
                  _buildTextField("Address", addressController),
                  const SizedBox(height: 16),
                  _buildTextField("Medical History", medicalHistoryController),
                  const SizedBox(height: 16),
                  _buildTextField("Certificate", certificateController),
                  const SizedBox(height: 16),
                  _buildTextField("License Number", licenseNumberController),
                  const SizedBox(height: 16),
                  _buildTextField("Gender", genderController),
                  const SizedBox(height: 20),


                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 350,
                      child: MaterialButton(
                          onPressed: () async {




                            if (firstNameController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please add your first name",
                              );
                            }
                            else if (lastNameController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please add your last name",
                              );
                            }
                            else if (mobileController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please add your mobile number",
                              );
                            }
                            else if (birthdateController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please enter your birthdate",
                              );
                            }
                            else if (emailController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please enter your email",
                              );
                            }
                            else if (workplaceController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please enter your workplace",
                              );
                            }
                            else if (addressController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please enter your address",
                              );
                            }
                            else if (medicalHistoryController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please enter your medical history",
                              );
                            }
                            else if (certificateController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title:
                                "Please enter your certificate information",
                              );
                            }
                            else if (licenseNumberController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please enter your license number",
                              );
                            }
                            else if (genderController.text.isEmpty) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                width: 400,
                                title: "Please enter your gender",
                              );
                            }
                            else {
                            showLoadingDialog(context);
                            if (profileImage != null) {
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

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 25, left: 25),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: Text(label, style: textStyle(fontSize: 15)),
        ),
        const SizedBox(height: 5),
        InputTextWidget("", controller,), // Assuming InputTextWidget accepts an 'obscureText' parameter
        const SizedBox(height: 16),
      ],
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
    final destination = 'doctors_profile_images/$fileName';

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
      "mobile": mobileController.text,
      "birthdate": birthdateController.text,
      "email": emailController.text,
      "workplace": workplaceController.text,
      "address": addressController.text,
      "medicalHistory": medicalHistoryController.text,
      "certificate": certificateController.text,
      "licenseNumber": licenseNumberController.text,
      "gender": genderController.text,
    };

    String? user_id = FirebaseAuth.instance.currentUser?.uid;
    if(user_id != null){

      await Provider.of<DataController>(context, listen: false).updateVeterinarianProfile(
        user_id: user_id,
        data: data
      );
      Navigator.pop(context);
      CoolAlert.show(context: context, type: CoolAlertType.success ,width: 400, title: "Your account updated successfully" ,
          closeOnConfirmBtnTap: false,
          onConfirmBtnTap: (){
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
            // Navigator.of(context).pop(true);
          }
      );
    }
  }

}
