// To parse this JSON data, do
//
//     final veterinarianSession = veterinarianSessionFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

VeterinarianSession veterinarianSessionFromJson(String str) => VeterinarianSession.fromJson(json.decode(str));

String veterinarianSessionToJson(VeterinarianSession data) => json.encode(data.toJson());

class VeterinarianSession {
  final String? petOwnerId;
  final String? sessionID;
  final String? veterinarianId;
  final String? veterinarianName;
  final Timestamp? timestamp;
  final String? petOwnerName;
  final String? status;

  VeterinarianSession({
    this.petOwnerId,
    this.veterinarianId,
    this.sessionID,
    this.timestamp,
    this.veterinarianName,
    this.petOwnerName,
    this.status,
  });

  factory VeterinarianSession.fromJson(Map<String, dynamic> json) => VeterinarianSession(
    petOwnerId: json["petOwnerID"],
    veterinarianId: json["veterinarianId"],
    timestamp: json["timestamp"],
    sessionID: json["sessionID"],
    veterinarianName: json["veterinarianName"],
    petOwnerName: json["petOwnerName"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "petOwnerID": petOwnerId,
    "veterinarianName": veterinarianName,
    "sessionID": sessionID,
    "veterinarianId": veterinarianId,
    "timestamp": FieldValue.serverTimestamp(),
    "petOwnerName": petOwnerName,
    "status": status,
  };
}
