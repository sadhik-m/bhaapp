// To parse this JSON data, do
//
//     final vendorShopModel = vendorShopModelFromJson(jsonString);

import 'dart:convert';

VendorShopModel vendorShopModelFromJson(String str) => VendorShopModel.fromJson(json.decode(str));

String vendorShopModelToJson(VendorShopModel data) => json.encode(data.toJson());

class VendorShopModel {
  VendorShopModel({
    required this.vendorId,
    required this.shopName,
    required this.vendorDocId,
    required this.image,
    required this.address,
    required this.closeTime,
    required this.openTime,
    required this.phone,
    required this.email,
    required this.shopType,
    required this.razorpayId,
  });

  String vendorId;
  String shopName;
  String vendorDocId;
  String image;
  String address;
  String closeTime;
  String openTime;
  String phone;
  String email;
  String shopType;
  String razorpayId;

  factory VendorShopModel.fromJson(Map<String, dynamic> json) => VendorShopModel(
    vendorId: json["vendorId"],
    shopName: json["shopName"],
    vendorDocId: json["vendorDocId"],
    image: json["image"],
    address: json["address"],
    closeTime: json["closeTime"],
    openTime: json["openTime"],
    phone: json["phone"],
    email: json["email"],
    shopType: json["shopType"],
    razorpayId: json["razorpayId"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "shopName": shopName,
    "vendorDocId": vendorDocId,
    "image": image,
    "address": address,
    "closeTime": closeTime,
    "openTime": openTime,
    "phone": phone,
    "email": email,
    "shopType": shopType,
    "razorpayId": razorpayId,
  };
}
