// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.prodDocId,
    required this.image,
    required this.name,
    required this.salePrice,
    required this.regularPrice,
    required this.priceUnit,
    required this.subCategory,
    required this.availableInStock,
  });

  String prodDocId;
  String image;
  String name;
  String salePrice;
  String regularPrice;
  String priceUnit;
  String subCategory;
  bool availableInStock;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    prodDocId: json["prodDocId"],
    image: json["image"],
    name: json["name"],
    salePrice: json["salePrice"],
    regularPrice: json["regularPrice"],
    priceUnit: json["priceUnit"],
    subCategory: json["subCategory"],
    availableInStock: json["availableInStock"],
  );

  Map<String, dynamic> toJson() => {
    "prodDocId": prodDocId,
    "image": image,
    "name": name,
    "salePrice": salePrice,
    "regularPrice": regularPrice,
    "priceUnit": priceUnit,
    "subCategory": subCategory,
    "availableInStock": availableInStock,
  };
}
