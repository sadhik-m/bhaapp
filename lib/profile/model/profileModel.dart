// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.country,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });

  String country;
  String name;
  String email;
  String phone;
  String image;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    country: json["country"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "name": name,
    "email": email,
    "phone": phone,
    "image": image,
  };
}
