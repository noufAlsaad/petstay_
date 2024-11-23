// To parse this JSON data, do
//
//     final carProviderSlot = carProviderSlotFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CarProviderSlot carProviderSlotFromJson(String str) => CarProviderSlot.fromJson(json.decode(str));

String carProviderSlotToJson(CarProviderSlot data) => json.encode(data.toJson());


class CarProviderSlot {
  final String? date;
   String? slotID;
  final String? careProviderId;
  final String? careProviderName;
  final String? fromTime;
  final Timestamp? addedAt;
  final String? status;
  final String? petOwnerEmail;
  final String? petOwnerId;
  final int? slotPrice;
  final String? serviceID;
  final String? serviceName;

  CarProviderSlot({
    this.date,
    this.careProviderId,
    this.careProviderName,
    this.slotPrice,
    this.slotID,
    this.fromTime,
    this.addedAt,
    this.serviceID,
    this.serviceName,
    this.status,
    this.petOwnerId,
    this.petOwnerEmail,
  });

  factory CarProviderSlot.fromJson(Map<String, dynamic> json) => CarProviderSlot(
    date: json["date"],
    careProviderId: json["care_provider_id"],
    careProviderName: json["care_provider_name"],
    fromTime: json["from_time"],
    slotPrice: json["slot_price"],
    addedAt: json["added_at"],
    slotID: json["slotID"],
    status: json["status"],
    petOwnerId: json["pet_owner_id"],
    petOwnerEmail: json["pet_owner_email"],
    serviceID: json["service_id"],
    serviceName: json["service_name"],
  );
  Map<String, dynamic> toJson() => {
    "date": date,
    "slotID": slotID,
    "care_provider_id": careProviderId,
    "care_provider_name": careProviderName,
    "from_time": fromTime,
    "added_at": FieldValue.serverTimestamp(),
    "status": status,
    "slot_price": slotPrice,
    "pet_owner_id": petOwnerId,
    "pet_owner_email": petOwnerEmail,
    "service_id": serviceID,
    "service_name": serviceName,
  };
}
