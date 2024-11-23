import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:intl/intl.dart';

import '../model/carProviderSlotModel.dart';
import '../model/petVeterinarianModel.dart';
import '../model/petCareModel.dart';
import '../model/petOwnerModel.dart';
import '../model/veterinarianSessionModel.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class UserController with ChangeNotifier{
  // notifyListeners();
  PetOwnerProfile? userPetOwnerProfile ;
  PetCareProfile? userCarProviderProfile ;
  PetVeterinarian? petVeterinarian ;
  List<CarProviderSlot>? userCarProviderSchedule ;


  Future<UserCredential> loginUser(String email, String password) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } catch (e) {
      print("Error logging in: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<Map<String, dynamic>?> getNormalUserData(String uid) async {
    try {
      var user_doc_pet_owner = await FirebaseFirestore.instance.collection('pet_owner_users').doc(uid).get();
      if(user_doc_pet_owner.data() != null){
        return user_doc_pet_owner.data();
      }

      var user_doc_care_provider = await FirebaseFirestore.instance.collection('care_provider_users').doc(uid).get();
      if(user_doc_care_provider.data() != null){
        return user_doc_care_provider.data();
      }

      var user_doc_veterinarian = await FirebaseFirestore.instance.collection('veterinarian_users').doc(uid).get();
      if(user_doc_veterinarian.data() != null){
        return user_doc_veterinarian.data();
      }


    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future getPetOwnerProfile(String uid) async {
    try {

      var user_doc_care_provider = await FirebaseFirestore.instance.collection('pet_owner_users').doc(uid).get();
      if(user_doc_care_provider.data() != null){
        // return user_doc_care_provider.data();
        PetOwnerProfile data = PetOwnerProfile.fromJson(user_doc_care_provider.data() as Map<String, dynamic>);
        userPetOwnerProfile = data ;
        notifyListeners();
      }

    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }


  Future getCareProviderProfile(String uid) async {
    try {

      var user_doc_care_provider = await FirebaseFirestore.instance.collection('care_provider_users').doc(uid).get();
      if(user_doc_care_provider.data() != null){
        // return user_doc_care_provider.data();
        PetCareProfile data = PetCareProfile.fromJson(user_doc_care_provider.data() as Map<String, dynamic>);
        userCarProviderProfile = data ;
        notifyListeners();
      }

    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }


  Future getVeterinarianProfile(String uid) async {
    try {

      var user_doc_care_provider = await FirebaseFirestore.instance.collection('veterinarian_users').doc(uid).get();
      if(user_doc_care_provider.data() != null){
        // return user_doc_care_provider.data();
        PetVeterinarian data = PetVeterinarian.fromJson(user_doc_care_provider.data() as Map<String, dynamic>);
        petVeterinarian = data ;
        notifyListeners();
      }

    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }


  Future<double?> getCareProviderEarnings(String uid) async {
    try {
      double earnings = 0 ;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("care_provider_earnings")
          .where("care_provider_id", isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> dataa = document.data() as Map<String, dynamic> ;
          earnings = earnings + double.parse("${dataa["slot_price"]??0.0}");
        }
        return earnings ;
      }


    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<PetCareProfile?> getCareProviderProfileForOwner(String uid) async {
    try {

      var user_doc_care_provider = await FirebaseFirestore.instance.collection('care_provider_users').doc(uid).get();
      if(user_doc_care_provider.data() != null){
        // return user_doc_care_provider.data();
        PetCareProfile data = PetCareProfile.fromJson(user_doc_care_provider.data() as Map<String, dynamic>);
        return data ;
      }

    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<List?> getCareProviderSchedule(String uid) async {
    try {

      List<CarProviderSlot> list = [] ;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("care_provider_schedule")
          .where("care_provider_id", isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          CarProviderSlot data = CarProviderSlot.fromJson(document.data() as Map<String, dynamic>);
          data.slotID = document.id;
          list.add(data);
        }
        list.sort((a, b) {
          DateTime dateA = DateTime.parse("${a.date!.split('-')[2]}-${a.date!.split('-')[1]}-${a.date!.split('-')[0]}");
          DateTime dateB = DateTime.parse("${b.date!.split('-')[2]}-${b.date!.split('-')[1]}-${b.date!.split('-')[0]}");
          return dateA.compareTo(dateB);
        });
        userCarProviderSchedule = list ;
        notifyListeners();
      }


    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<List<CarProviderSlot>?> getSlotsDependOnService(String service_id ) async {
    try {
      print("service_id ${service_id}");
      List<CarProviderSlot> list = [] ;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("care_provider_schedule").where("service_id", isEqualTo: service_id).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          CarProviderSlot data = CarProviderSlot.fromJson(document.data() as Map<String, dynamic>);
          data.slotID = document.id;
          list.add(data);
        }

        list.sort((a, b) {
          DateTime dateA = DateTime.parse("${a.date!.split('-')[2]}-${a.date!.split('-')[1]}-${a.date!.split('-')[0]}");
          DateTime dateB = DateTime.parse("${b.date!.split('-')[2]}-${b.date!.split('-')[1]}-${b.date!.split('-')[0]}");
          return dateA.compareTo(dateB);
        });
        return list ;
      }


    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<List<CarProviderSlot>?> getOwnerBooking(String userID ) async {
    try {
      List<CarProviderSlot> list = [] ;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("care_provider_schedule").where("pet_owner_id", isEqualTo: userID).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          CarProviderSlot data = CarProviderSlot.fromJson(document.data() as Map<String, dynamic>);
          data.slotID = document.id;
          list.add(data);
        }

        list.sort((a, b) {
          DateTime dateA = DateTime.parse("${a.date!.split('-')[2]}-${a.date!.split('-')[1]}-${a.date!.split('-')[0]}");
          DateTime dateB = DateTime.parse("${b.date!.split('-')[2]}-${b.date!.split('-')[1]}-${b.date!.split('-')[0]}");
          return dateA.compareTo(dateB);
        });

        return list ;
      }


    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }




  Future<bool?>? bookSlot(PetOwnerProfile petOwnerProfile , String slotID) async {
    try{
      Map<String, dynamic> updated_data = {
        "pet_owner_email" : petOwnerProfile.email,
        "pet_owner_id" : FirebaseAuth.instance.currentUser!.uid,
        "status" : "booked",
      };
      await FirebaseFirestore.instance.collection('care_provider_schedule').doc(slotID).update(updated_data);

      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }

  Future<bool?>? deleteSlot( String slotID) async {
    try{
      await FirebaseFirestore.instance.collection('care_provider_schedule').doc(slotID).delete();

      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?>? getRatingBySlot(CarProviderSlot slot) async {
    try {

      var data = await FirebaseFirestore.instance.collection('care_provider_rating').where("slotID", isEqualTo: slot.slotID).get();
      if (data.docs.isNotEmpty) {
        return data.docs.first.data() as Map<String, dynamic>;
      }


    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<Map<String, dynamic>?>? getRatingBySession(VeterinarianSession veterinarianSession) async {
    try {

      var data = await FirebaseFirestore.instance.collection('veterinarian_session_rating').where("sessionID", isEqualTo: veterinarianSession.sessionID).get();
      if (data.docs.isNotEmpty) {
        return data.docs.first.data() as Map<String, dynamic>;
      }


    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }



  Future<bool?>? addPetCareProviderRate(CarProviderSlot slot , double rating) async {
    try{
      Map<String, dynamic> updated_data = {
        "rating" : rating ,
        ...slot.toJson()
      };
      await FirebaseFirestore.instance.collection('care_provider_rating').doc().set(updated_data);
      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }


  Future<bool?>? addVeterinarianRate(VeterinarianSession session , double rating) async {
    try{
      Map<String, dynamic> updated_data = {
        "rating" : rating ,
        ...session.toJson()
      };
      await FirebaseFirestore.instance.collection('veterinarian_session_rating').doc().set(updated_data);
      await completeSession(session);
      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }

  Future<bool?>? completeSession(VeterinarianSession session) async {
    try{
      Map<String, dynamic> updated_data = {
        "status" : "Completed",
      };
      await FirebaseFirestore.instance.collection('sessions').doc(session.sessionID).update(updated_data);
      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }



  Future<bool?>? completeSlot(CarProviderSlot slot) async {
    try{
      Map<String, dynamic> updated_data = {
        "status" : "Completed",
      };
      await FirebaseFirestore.instance.collection('care_provider_schedule').doc(slot.slotID).update(updated_data);
      addEarningsForPetCare(slot);
      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }



  Future<bool?>? addEarningsForPetCare(CarProviderSlot slot) async {
    try{

      Map<String, dynamic> data = {
        "added_at": FieldValue.serverTimestamp(),
        "status" : "booked",
        ...slot.toJson(),

      };

      await FirebaseFirestore.instance.collection('care_provider_earnings').doc().set(data);

      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }


  Future<bool?>? addCareProviderSlot(CarProviderSlot slot) async {
    try{

      await FirebaseFirestore.instance.collection('care_provider_schedule').doc().set(slot.toJson());

      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }


  Future saveLoginData(Map<String, dynamic>? userData) async {
    Map<String, dynamic> userDataN = {
      'current_datetime': DateTime.now().toIso8601String()
    };
    userData!.addAll(userDataN);

    await FirebaseFirestore.instance
        .collection('login_session')
        .doc()
        .set(userData);
  }

  Future<bool?> registerPetOwner(String email, String password ,BuildContext context , PetOwnerProfile profileData) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access user information
      User? user = userCredential.user;
      if(user != null){
        await FirebaseFirestore.instance.collection('pet_owner_users').doc(user.uid).set(profileData.toJson());
        return true ;
      }
      // print('User registered: ${user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');
        CoolAlert.show(
          width: 400,
          context: context,
          type: CoolAlertType.error,
          text: "The email address is already in use by another account.",
        );

        return null;
      } else {
        print('Error registering user: ${e.message}');
        CoolAlert.show(
          width: 400,
          context: context,
          type: CoolAlertType.error,
          text: 'Error registering user: ${e.message}',
        );
        return null;
      }
    } catch (e) {
      print('Error registering user: $e');
      CoolAlert.show(width: 400,
        context: context,
        type: CoolAlertType.error,
        text: 'Error registering user: $e',
      );
      // Handle generic errors
      return null;
    }
    return null;
  }

 Future<bool?> registerVeterinarian(String email, String password ,BuildContext context , PetVeterinarian profileData) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access user information
      User? user = userCredential.user;
      if(user != null){
        await FirebaseFirestore.instance.collection('veterinarian_users').doc(user.uid).set(profileData.toJson());
        return true ;
      }
      // print('User registered: ${user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');
        CoolAlert.show(
          width: 400,
          context: context,
          type: CoolAlertType.error,
          text: "The email address is already in use by another account.",
        );

        return null;
      } else {
        print('Error registering user: ${e.message}');
        CoolAlert.show(
          width: 400,
          context: context,
          type: CoolAlertType.error,
          text: 'Error registering user: ${e.message}',
        );
        return null;
      }
    } catch (e) {
      print('Error registering user: $e');
      CoolAlert.show(width: 400,
        context: context,
        type: CoolAlertType.error,
        text: 'Error registering user: $e',
      );
      // Handle generic errors
      return null;
    }
    return null;
  }

 Future<bool?> registerPetCareProvider(String email, String password ,BuildContext context , PetCareProfile profileData) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access user information
      User? user = userCredential.user;
      if(user != null){
        await FirebaseFirestore.instance.collection('care_provider_users').doc(user.uid).set(profileData.toJson());
        return true ;
      }
      // print('User registered: ${user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');
        CoolAlert.show(
          width: 400,
          context: context,
          type: CoolAlertType.error,
          text: "The email address is already in use by another account.",
        );

        return null;
      } else {
        print('Error registering user: ${e.message}');
        CoolAlert.show(
          width: 400,
          context: context,
          type: CoolAlertType.error,
          text: 'Error registering user: ${e.message}',
        );
        return null;
      }
    } catch (e) {
      print('Error registering user: $e');
      CoolAlert.show(width: 400,
        context: context,
        type: CoolAlertType.error,
        text: 'Error registering user: $e',
      );
      // Handle generic errors
      return null;
    }
    return null;
  }

  Future<bool?> updateUserData(String uid, Map<String, dynamic> updatedData) async {
    try {
      // Reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // Update specific fields in the user document
      await userRef.update(updatedData);

      print('User data updated successfully!');
      return true ;
    } catch (e) {
      print('Error updating user data: $e');
      return false ;
    }
  }




  Future<bool?> changeUserPassword(String email, String currentPassword, String newPassword) async {
    try {
      // Re-authenticate the user with their current credentials
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null){
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);

        print('Password updated successfully!');
        return true ;
      }
    } catch (e) {
      print('Error changing password: ${e}');
      // Handle errors, e.g., show a snackbar or display an error message
      throw e;
      return false ;
    }
  }

}