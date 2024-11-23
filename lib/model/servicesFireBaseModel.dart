// To parse this JSON data, do
//
//     final services = servicesFromJson(jsonString);

import 'dart:convert';

Services servicesFromJson(String str) => Services.fromJson(json.decode(str));

String servicesToJson(Services data) => json.encode(data.toJson());

class Services {
  final String? name;
  final String? id;
  final String? image;

  Services({
    this.name,
    this.image,
    this.id,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
    name: json["name"],
    image: json["image"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "id": id,
  };
}
