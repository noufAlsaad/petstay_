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


class SignUpVeterinarianScreen extends StatefulWidget {
  const SignUpVeterinarianScreen({super.key});

  @override
  State<SignUpVeterinarianScreen> createState() => _SignUpVeterinarianScreenState();
}
class _SignUpVeterinarianScreenState extends State<SignUpVeterinarianScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController workPlaceController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  bool isHidden = true;
  DateTime? birthDate;

  List<PetOwnerProfile> petOwnerData = [] ;
  List<PetVeterinarian> veterinarianUsersData = [] ;
  List<PetCareProfile> petCareProviderData = [] ;

  // List<String> countries = [] ;
  // String? selectedCountry ;



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

                      Text("Create Account as pet veterinarian", style: textStyle(fontSize: 18 ,color: MyStyle.mainColor, fontWeight: FontWeight.bold)),
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


                      // Phone Number
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Phone Number", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),
                      InputTextWidget("", phoneController),
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
                              hintText: 'Area',
                              border: InputBorder.none, // Removes the default underline
                              fillColor: MyStyle.grey200,
                            ),
                            value: selectedArea,
                            items: areas.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                            onChanged: (newValue){
                              setState(() {
                                selectedArea = newValue ;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      */
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Birth date", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: (){
                          MyDatePicker().selectDate(context , birthDate).then((value) {
                            if(value != null){
                              setState(() {
                                final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
                                birthDateController.text = serverFormater.format(value);
                              });
                            }
                          });
                        },
                        child: InputTextWidget("" , isEnable: false ,birthDateController),
                      ),
                      const SizedBox(height: 16),

                      // Pet Type
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Work Place", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),
                      InputTextWidget(
                          "" , workPlaceController
                      ),
                      const SizedBox(height: 20),




                      // Password
                      Container(
                          padding:  EdgeInsets.only(right: 25, left: 25), margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),child: Text("Password", style: textStyle(fontSize: 15))),
                      const SizedBox(height: 5),
                      // InputTextWidget(
                      //     "" , passwordController
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







                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 350,
                          child: MaterialButton(
                              onPressed: () async {


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
                    "assets/images/pethotel9.JPG",
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

/// 
