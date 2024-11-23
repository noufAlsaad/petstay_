// To parse this JSON data, do
//
//     final petHotelProfile = petHotelProfileFromJson(jsonString);

import 'dart:convert';


class PetCareProfile {
  final String? hotelName;
  final String? profileDescription;
  final String? mobile;
  final String? email;
  final String? password;
  final String? hotelPlace;
  final String? profileImage;
  // final String? area;

  PetCareProfile({
    this.hotelName,
    this.mobile,
    this.profileDescription,
    this.profileImage,
    this.email,
    this.password,
    this.hotelPlace,
    // this.area,
  });

  factory PetCareProfile.fromJson(Map<String, dynamic> json) => PetCareProfile(
    hotelName: json["hotel_name"],
    mobile: json["mobile"],
    email: json["email"],
    password: json["password"],
    profileDescription: json["profile_description"],
    hotelPlace: json["hotel_place"],
    profileImage: json["profile_image"],
    // area: json["area"],
  );

  Map<String, dynamic> toJson() => {
    "hotel_name": hotelName,
    "profile_description": profileDescription,
    "profile_image": profileImage,
    "mobile": mobile,
    "email": email,
    "account_type": "care_provider",
    "password": password,
    "hotel_place": hotelPlace,
    // "area": area,
  };
}
