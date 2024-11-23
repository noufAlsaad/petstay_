// To parse this JSON data, do
//
//     final petOwnerNotification = petOwnerNotificationFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PetOwnerNotification petOwnerNotificationFromJson(String str) => PetOwnerNotification.fromJson(json.decode(str));

String petOwnerNotificationToJson(PetOwnerNotification data) => json.encode(data.toJson());

class PetOwnerNotification {
  final String? carProviderId;
  final Timestamp? addedAt;
  final String? carProviderName;
  final String? petOwnerId;
  final String? msg;

  PetOwnerNotification({
    this.carProviderId,
    this.addedAt,
    this.carProviderName,
    this.petOwnerId,
    this.msg,
  });

  factory PetOwnerNotification.fromJson(Map<String, dynamic> json) => PetOwnerNotification(
    carProviderId: json["car_provider_id"],
    addedAt: json["added_at"],
    carProviderName: json["car_provider_name"],
    petOwnerId: json["pet_owner_id"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "car_provider_id": carProviderId,
    "added_at": FieldValue.serverTimestamp(),
    "car_provider_name": carProviderName,
    "pet_owner_id": petOwnerId,
    "msg": msg,
  };
}
