// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.address,
    required this.country,
    required this.name,
    required this.email,
    required this.phone,
  });

  String address;
  String country;
  String name;
  String email;
  String phone;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    address: json["address"],
    country: json["country"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "country": country,
    "name": name,
    "email": email,
    "phone": phone,
  };
}
