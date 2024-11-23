// To parse this JSON data, do
//
//     final petOwnerProfile = petOwnerProfileFromJson(jsonString);

import 'dart:convert';

PetOwnerProfile petOwnerProfileFromJson(String str) => PetOwnerProfile.fromJson(json.decode(str));

String petOwnerProfileToJson(PetOwnerProfile data) => json.encode(data.toJson());

class PetOwnerProfile {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? petType;
  final String? petWeight;
  final String? petAge;
  final String? petHeight;
  final String? profileImage;

  PetOwnerProfile({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.petType,
    this.petWeight,
    this.petAge,
    this.profileImage,
    this.petHeight,
  });

  factory PetOwnerProfile.fromJson(Map<String, dynamic> json) => PetOwnerProfile(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    password: json["password"],
    profileImage: json["profile_image"],
    petType: json["pet_type"],
    petWeight: json["pet_weight"],
    petAge: json["pet_age"],
    petHeight: json["pet_height"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "password": password,
    "pet_type": petType,
    "account_type": "pet_owner",
    "profile_image": profileImage,
    "pet_weight": petWeight,
    "pet_age": petAge,
    "pet_height": petHeight,
  };
}
