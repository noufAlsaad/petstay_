import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:pethotel/controller/userController.dart';
import 'package:provider/provider.dart';

import '../../controller/styleController.dart';
import '../../controller/widgetController.dart';
import '../home/home_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool isHidden = true;
  bool isRemember = true;
  // String clientSecret = "sk_test_51LAfPIBPyxjcOtzS12WUSQh6PwMlkXW98MUL5kORPxxI2vmPtnWKzsEhU2SSyzeeE92RNXdkNohHdwy2kgOosfWu000sX4aKmX";
  // String stripePublishableKey =  "pk_test_51LAfPIBPyxjcOtzSjn9C4pk9PXBcFE2MCE3adjpGb8OesmULeZ1xXCY9pWWw6ysGnWtXn7ULIBh8qqRF0NoeUNYv00RGVHrvzw";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Stripe.publishableKey = const String.fromEnvironment('');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  "assets/images/logo.png",
                  scale: 2,
                  color: MyStyle.mainColor,
                ),
                const SizedBox(
                  height: (50),
                ),
                Container(
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Email",
                              style: textStyle(fontSize: 15),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(right: 25, left: 25),
                        child: Container(
                          child: TextFormField(
                            style: textStyle(
                              fontSize: 15,
                            ),
                            controller: emailTextController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              fillColor: MyStyle.grey200,
                              border: OutlineInputBorder(),
                              labelStyle: textStyle(),
                              contentPadding:
                              EdgeInsets.fromLTRB(24, 18, 24, 18),
                              filled: true,
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.0),
                              ),
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: (16),
                ),
                Container(
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Password",
                              style: textStyle(fontSize: 15),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(right: 25, left: 25),
                        child: Container(
                          child: TextFormField(
                            style: textStyle(
                              fontSize: 15,
                            ),
                            obscureText: isHidden,
                            controller: passwordTextController,
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
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: (20),
                ),
                Container(
                  width: 400,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        isRemember = !isRemember ;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: MyStyle.mainColor,
                          value: isRemember,
                          onChanged: (bool? value) {
                            setState(() {
                              isRemember = !isRemember ;
                            });
                          },

                        ),
                        Text('Remember me' , style: textStyle(),),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 25,
                ),

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 400,
                    child: MaterialButton(
                        onPressed: () async {


                            if(emailTextController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Enter email");



                              return ;
                            } else if(passwordTextController.text.isEmpty){
                              CoolAlert.show(context: context, type: CoolAlertType.error,width: 400, title: "Enter password");
                              return ;
                            }

                            CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading);
                            UserCredential userCredential = await Provider.of<UserController>(context , listen: false).loginUser(emailTextController.text,
                                passwordTextController.text);
                              print("Login successful! User ID: ${userCredential.user!.uid}");
                              Map<String, dynamic>? userData = await Provider.of<UserController>(context , listen: false).getNormalUserData(userCredential.user!.uid);

                              await Provider.of<UserController>(context , listen: false).saveLoginData(userData);
                             log("User Data: $userData");


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
                              "Sign in",
                              style: textStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: (10),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 400,
                    child: MaterialButton(
                        onPressed: () async {

                        },
                        color: MyStyle.grey200,
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
                              "Forget Password",
                              style: textStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyStyle.mainColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
              child: Container(
                // color: MyStyle.mainColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Image.asset(
                      "assets/images/pethotel10.JPG",
                      scale: 3,
                    ),

                    //
                    SizedBox(height: 50,),
                    Text("New Here?" , style: textStyle(fontSize: 15 , color: MyStyle.mainColor , fontWeight: FontWeight.bold),),
                    // Text("New Here?" , style: textStyle(fontSize: 15 , color: MyStyle.grey200 , fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text("You can also create account as ..." , style: textStyle(fontSize: 15 ,color: MyStyle.mainColor , fontWeight: FontWeight.bold),),
                    // Text("You can also create account as ..." , style: textStyle(fontSize: 15 ,color: MyStyle.grey200 , fontWeight: FontWeight.bold),),


                    SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            width: 150,
                            child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/SignUpPetOwner');
                                },
                                color: MyStyle.grey200,
                                elevation: 4,
                                // color: Theme_Information.Button_Color,
                                // color: MyStyle.mainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Pet Owner",
                                      style: textStyle(
                                          fontWeight: FontWeight.bold,
                                          color: MyStyle.mainColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            width: 150,
                            child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/SignUpCareProvider');

                                },
                                color: MyStyle.grey200,
                                elevation: 4,
                                // color: Theme_Information.Button_Color,
                                // color: MyStyle.mainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Care Provider",
                                      style: textStyle(
                                          fontWeight: FontWeight.bold,
                                          color: MyStyle.mainColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            width: 150,
                            child: MaterialButton(
                                onPressed: () {
                                  //
                                  Navigator.pushNamed(context, '/SignUpVeterinarian');

                                },
                                color: MyStyle.grey200,
                                elevation: 4,
                                // color: Theme_Information.Button_Color,
                                // color: MyStyle.mainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Veterinarian",
                                      style: textStyle(
                                          fontWeight: FontWeight.bold,
                                          color: MyStyle.mainColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(width: 10,),

                      ],
                    ),





                  ],
                ),
              )),


        ],
      ),
    );
  }


}
