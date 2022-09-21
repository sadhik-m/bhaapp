// To parse this JSON data, do
//
//     final vendorModel = vendorModelFromJson(jsonString);

import 'dart:convert';

VendorModel vendorModelFromJson(String str) => VendorModel.fromJson(json.decode(str));

String vendorModelToJson(VendorModel data) => json.encode(data.toJson());

class VendorModel {
  VendorModel({
    required this.vendorId,
    required this.shopName,
    required this.category,
    required this.address,
  });

  String vendorId;
  String shopName;
  String category;
  String address;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    vendorId: json["vendorId"],
    shopName: json["shopName"],
    category: json["category"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "shopName": shopName,
    "category": category,
    "address": address,
  };
}
