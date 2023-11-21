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
    required this.vendorDocId,
    required this.device_id,
  });

  String vendorId;
  String shopName;
  String category;
  String address;
  String vendorDocId;
  String device_id;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    vendorId: json["vendorId"],
    shopName: json["shopName"],
    category: json["category"],
    address: json["address"],
    vendorDocId: json["vendorDocId"],
    device_id: json["device_id"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "shopName": shopName,
    "category": category,
    "address": address,
    "vendorDocId": vendorDocId,
    "device_id": device_id,
  };
}
