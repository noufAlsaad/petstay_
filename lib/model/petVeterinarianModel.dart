// To parse this JSON data, do
//
//     final petCareProfile = petCareProfileFromJson(jsonString);

import 'dart:convert';


class PetVeterinarian {
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? birthdate;
  final String? email;
  final String? workplace;
  final String? password;
  final String? profileImage;
  final String? gender;
  final String? address;
  final String? medicalHistory;
  final String? certificate;
  final String? licenseNumber;
  // final String? area;

  PetVeterinarian({
    this.firstName,
    this.lastName,
    this.mobile,
    this.birthdate,
    this.email,
    this.workplace,
    this.password,
    this.profileImage,
    this.gender,
    this.address,
    this.medicalHistory,
    this.certificate,
    this.licenseNumber,
    // this.area,
  });

  factory PetVeterinarian.fromJson(Map<String, dynamic> json) => PetVeterinarian(
    firstName: json["first_name"],
    lastName: json["last_name"],
    mobile: json["mobile"],
    birthdate: json["birthdate"],
    gender: json["gender"],
    email: json["email"],
    licenseNumber: json["licenseNumber"],
    workplace: json["workplace"],
    password: json["password"],
    address: json["address"],
    certificate: json["certificate"],
    medicalHistory: json["medicalHistory"],
    profileImage: json["profileImage"],
    // area: json["area"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "gender": gender,
    "address": address,
    "last_name": lastName,
    "certificate": certificate,
    "medicalHistory": medicalHistory,
    "mobile": mobile,
    "licenseNumber": licenseNumber,
    "birthdate": birthdate,
    "email": email,
    "account_type": "veterinarian_user",
    "workplace": workplace,
    "password": password,
    "profileImage": profileImage,
    // "area": area,
  };
}
