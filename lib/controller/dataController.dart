import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/petOwnerNotificationModel.dart';
import '../model/petVeterinarianModel.dart';
import '../model/petCareModel.dart';
import '../model/petOwnerModel.dart';
import '../model/servicesFireBaseModel.dart';


class DataController with ChangeNotifier{
  // notifyListeners();


  Future getPetOwnerData( List<PetOwnerProfile> _list) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection("pet_owner_users").get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          PetOwnerProfile userProfile = PetOwnerProfile.fromJson(document.data() as Map<String, dynamic>);
          _list.add(userProfile);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future getCareProviderData( List<PetCareProfile> _list) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection("care_provider_users").get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          PetCareProfile userProfile = PetCareProfile.fromJson(document.data() as Map<String, dynamic>);
          _list.add(userProfile);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future getPetVeterinarianData( List<PetVeterinarian> _list) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection("veterinarian_users").get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          PetVeterinarian userProfile = PetVeterinarian.fromJson(document.data() as Map<String, dynamic>);
          _list.add(userProfile);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  Future getPetVeterinarianUser( String userID) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final  querySnapshot = await firestore.collection("veterinarian_users").doc(userID).get();

      if(querySnapshot.data() != null){
        // return user_doc_care_provider.data();
        PetVeterinarian data = PetVeterinarian.fromJson(querySnapshot.data() as Map<String, dynamic>);
        return data ;
        // notifyListeners();
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  Future<String?> getCareProviderAccountByEmail(String email) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {

      QuerySnapshot querySnapshot = await firestore
          .collection("care_provider_users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          // Map<String, dynamic> data =  document.data() as Map<String, dynamic> ;
          log("dddd____ ${document.id}");
          // log("dddd____ $data");
          return document.id ;
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<PetOwnerProfile?> getPetOwnerProfile(String uid) async {
    try {

      var user_doc_care_provider = await FirebaseFirestore.instance.collection('pet_owner_users').doc(uid).get();
      if(user_doc_care_provider.data() != null){
        // return user_doc_care_provider.data();
        PetOwnerProfile data = PetOwnerProfile.fromJson(user_doc_care_provider.data() as Map<String, dynamic>);
        return data ;
        // notifyListeners();
      }

    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<List<Services>?> fetchCareProviderServicesFromFirestore(List<Services> _list , {bool mine = false ,String? userID}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    userID ??= FirebaseAuth.instance.currentUser!.uid;
    try {
      QuerySnapshot querySnapshot = mine ?
      await firestore.collection("pet_care_services_selected").where("car_provider_id", isEqualTo: userID).get()
          :
      await firestore.collection("pet_care_services").get()  ;

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          // log("ddd__d_ ${document.data()}");

          _list.add(
              Services(
                name: document.data().toString().contains('name') ? document.get('name') : '',
                image: document.data().toString().contains('image') ? document.get('image') : '',
                id: document.data().toString().contains('id') ? document.get('id') : ''
              ));
        }
      }
      return _list ;
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future removeAllItems() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection("pet_care_services_selected").where("car_provider_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection("pet_care_services_selected")
              .doc(document.id)
              .delete();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


 Future addServicesSelectedItems(List<Services> items) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
        for (Services item in items) {
          // Get a reference to a new document with an auto-generated ID
          DocumentReference documentReference = firestore.collection("pet_care_services_selected").doc();

          await documentReference.set({
            'car_provider_id': FirebaseAuth.instance.currentUser!.uid,
            'id': item.id,
            'name': item.name,
          });
        }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


 Future sendNotificationToPetOwner(String text , String petOwnerID , String careProviderName) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentReference documentReference = firestore.collection("pet_owner_notifications").doc();
      PetOwnerNotification data = PetOwnerNotification(
        carProviderId: FirebaseAuth.instance.currentUser!.uid,
        carProviderName: careProviderName,
        msg: text,
        petOwnerId: petOwnerID
      );
      await documentReference.set({data.toJson()});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


 Future<List<PetOwnerNotification>?> getPetOwnerNotification(String petOwnerID ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<PetOwnerNotification> _list = [] ;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection("pet_owner_notifications").where("pet_owner_id", isEqualTo: petOwnerID).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          // log("ddd__d_ ${document.data()}");
          _list.add(
              PetOwnerNotification(
                  petOwnerId: document.data().toString().contains('pet_owner_id') ? document.get('pet_owner_id') : '',
                  carProviderId: document.data().toString().contains('car_provider_id') ? document.get('car_provider_id') : '',
                  carProviderName: document.data().toString().contains('car_provider_name') ? document.get('car_provider_name') : '' ,
                  msg: document.data().toString().contains('msg') ? document.get('msg') : '',
                  addedAt: document.data().toString().contains('added_at') ? document.get('added_at') : '',
              ));
        }
      }
      return _list ;
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  Future<String?> getPetOwnerAccountByEmail(String email) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {

      QuerySnapshot querySnapshot = await firestore
          .collection("pet_owner_users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          // Map<String, dynamic> data =  document.data() as Map<String, dynamic> ;
          log("dddd____ ${document.id}");
          // log("dddd____ $data");
          return document.id ;
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }



  Future<bool?>? updateCareProviderProfile({required user_id , required Map<String, dynamic> carProviderData}) async {
    try {

      await FirebaseFirestore.instance.collection('care_provider_users').doc(user_id).update(carProviderData);
      return true;
    } catch (e) {
      // Handle errors here
      print('Error updating data: $e');
      return null;
    }
  }

  Future<bool?>? updateVeterinarianProfile({required user_id , required Map<String, dynamic> data}) async {
    try {

      await FirebaseFirestore.instance.collection('veterinarian_users').doc(user_id).update(data);
      return true;
    } catch (e) {
      // Handle errors here
      print('Error updating data: $e');
      return null;
    }
  }

  Future<bool?>? updatePetOwnerProfile({required user_id , required Map<String, dynamic> petOwnerData}) async {
    try {

      await FirebaseFirestore.instance.collection('pet_owner_users').doc(user_id).update(petOwnerData);
      return true;
    } catch (e) {
      // Handle errors here
      print('Error updating data: $e');
      return null;
    }
  }

}