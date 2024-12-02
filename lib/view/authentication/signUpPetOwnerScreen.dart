/// 
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pethotel/controller/dataController.dart';
import 'package:pethotel/controller/styleController.dart';
import 'package:pethotel/controller/userController.dart';
import 'package:provider/provider.dart';
import '../../controller/widgetController.dart';
import '../../model/petVeterinarianModel.dart';
import '../../model/petCareModel.dart';
import '../../model/petOwnerModel.dart';
import '../home/home_page.dart';


class SignUpPetOwnerScreen extends StatefulWidget {
  const SignUpPetOwnerScreen({super.key});

  @override
  State<SignUpPetOwnerScreen> createState() => _SignUpPetOwnerScreenState();
}
class _SignUpPetOwnerScreenState extends State<SignUpPetOwnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController petTypeController = TextEditingController();
  final TextEditingController petAgeController = TextEditingController();
  final TextEditingController petWeightController = TextEditingController();
  final TextEditingController petHeightController = TextEditingController();
  bool isHidden = true;
  List<PetOwnerProfile> petOwnerData = [] ;
  List<PetVeterinarian> veterinarianUsersData = [] ;
  List<PetCareProfile> petCareProviderData = [] ;

  // List<String> countries = [] ;
  // String? selectedCountry ;

  List<String> petTypes = ['Dog', 'Cat', 'Bird', 'Fish', 'Reptile'];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      // countries.add("Saudi arabia");
      await Provider.of<DataController>(context, listen: false).getPetOwnerData(petOwnerData);
      await Provider.of<DataController>(context, listen: false).getCareProviderData(petCareProviderData);
      await Provider.of<DataController>(context, listen: false).getPetVeterinarianData(veterinarianUsersData);
      setState(() {});
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [



          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      Text("Create Account as pet owner", style: textStyle(fontSize: 18 ,color: MyStyle.mainColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),

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

                      // Email
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25) , margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Email", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),
                      InputTextWidget("", emailController),
                      const SizedBox(height: 16),
                      /*
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Area", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),

                       Padding(
                    padding:  EdgeInsets.only(right: 25, left: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyStyle.grey200,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: DropdownButtonFormField<String>(
                            dropdownColor: MyStyle.grey200,
                            borderRadius: BorderRadius.circular(15.0),
                            isExpanded: true,
                            decoration: InputDecoration(
                              hintStyle: textStyle(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                const BorderSide(color: Colors.transparent, width: 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                const BorderSide(color: Colors.transparent, width: 0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                const BorderSide(color: Colors.transparent, width: 0),
                              ),
                              hintText: 'Country',
                              border: InputBorder.none, // Removes the default underline
                              fillColor: MyStyle.grey200,
                            ),
                            value: selectedCountry,
                            items: countries.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                            onChanged: (newValue){
                              setState(() {
                                selectedCountry = newValue ;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                        */


                      // Password
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Password", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),
                      // InputTextWidget(
                      //   "" , passwordController
                      // ),

                      Padding(
                        padding: EdgeInsets.only(right: 25, left: 25),
                        child: Container(
                          child: TextFormField(
                            style: textStyle(
                              fontSize: 15,
                            ),
                            obscureText: isHidden,
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              fillColor: MyStyle.grey200,
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isHidden = !isHidden;
                                    });
                                  },
                                  child: isHidden
                                      ? Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: MyStyle.mainColor)
                                      : Icon(
                                    Icons.remove_red_eye,
                                    color: MyStyle.mainColor,
                                  )),
                              contentPadding:
                              EdgeInsets.fromLTRB(24, 18, 24, 18),
                              filled: true,
                              labelStyle: textStyle(),
                              // fillColor: MyStyle.Icon_Back_Color,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.0),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),



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
                      ///
                      //   AgeSliderWidget(
                      //     textEditingController: petAgeController,
                      //   ),
                      ///
                      AgeDropdownWidget(
                        textEditingController: petAgeController,
                      ),


                      const SizedBox(height: 20),


                      // Pet weight
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Pet Weight", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),
                      // InputTextWidget(
                      //     "" , petWightController
                      // ),

                      WeightDropdownWidget(
                        weightController: petWeightController,
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
                                } else  if(emailController.text.isEmpty){
                                  CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Please add the email address");
                                  return ;
                                } else   if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(emailController.text)) {
                                  CoolAlert.show(context: context, type: CoolAlertType.error,width: 400 ,  title: 'Please enter a valid email address');
                                }
                                else if (isPetOwnerEmailExists(email: emailController.text)) {
                                  CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Email is exists!");
                                }
                                else if (isPetVeterinarianEmailExists(email: emailController.text)) {
                                  CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Email is exists!");
                                }
                                else if (isPetCareProviderEmailExists(email: emailController.text)) {
                                  CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Email is exists!");
                                }
                                else  if(passwordController.text.isEmpty){
                                  CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Please enter the password");
                                }
                                else  if(petWeightController.text.isEmpty){
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
                                // else if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$').hasMatch(passwordController.text)) {
                                //   CoolAlert.show(context: context, type: CoolAlertType.error,width: 400 , title: "Please enter a valid  password");
                                // }
                                else if (passwordController.text.length < 8) {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    width: 400,
                                    title: "Password must be at least 8 characters long.",
                                  );
                                } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(passwordController.text)) {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    width: 400,
                                    title: "Password must contain at least one uppercase letter.",
                                  );
                                } else if (!RegExp(r'(?=.*\d)').hasMatch(passwordController.text)) {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    width: 400,
                                    title: "Password must contain at least one digit.",
                                  );
                                } else if (!RegExp(r'(?=.*[\W_])').hasMatch(passwordController.text)) {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    width: 400,
                                    title: "Password must contain at least one special character.",
                                  );
                                }
                                ///
                                // else if(selectedCountry == null) {
                                //   CoolAlert.show(context: context, type: CoolAlertType.error, width: 400,title: "Please select country");
                                // }
                                else {

                                  PetOwnerProfile petOwnerProfile = PetOwnerProfile(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    password:  passwordController.text,
                                    petAge: petAgeController.text,
                                    petHeight: petHeightController.text,
                                    petType: petTypeController.text,
                                    petWeight: petWeightController.text,
                                  );

                                  CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading);
                                  await Provider.of<UserController>(context , listen: false).registerPetOwner(emailController.text ,
                                      passwordController.text , context , petOwnerProfile )
                                      .then((value) {
                                    if(value != null){
                                      if(value == true){
                                        Navigator.of(context).pop();


                                        CoolAlert.show(context: context, type: CoolAlertType.success ,width: 400, title: "Thanks for register in our app, You can login now" ,
                                        onConfirmBtnTap: (){
                                          Navigator.of(context).pop();
                                        }
                                        );
                                        // RegisteredSuccessfullyPage
                                        // Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => RegisteredSuccessfullyPage()));
                                        // Navigator.of(context).pop();
                                        return;
                                      } else{

                                        CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "There is a problem , Please try again");
                                      }
                                    }
                                  });




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
                                    "Create Account",
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
          ),


          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Image.asset(
                    "assets/images/pethotel3.jpeg",
                  ),


                ],
              )),

          SizedBox(width: 50,)

        ],
      ),
    );
  }


  bool isPetOwnerEmailExists({required String email}) {
    for (PetOwnerProfile user in petOwnerData) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

  bool isPetCareProviderEmailExists({required String email}) {
    for (PetCareProfile user in petCareProviderData) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

  bool isPetVeterinarianEmailExists({required String email}) {
    for (PetVeterinarian user in veterinarianUsersData) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

}
