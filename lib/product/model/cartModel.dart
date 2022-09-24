import 'dart:convert';

class CartModel {
   String productId;
   int productQuantity;

  CartModel({
    required this.productId,
    required this.productQuantity,

  });

  factory CartModel.fromJson(Map<String, dynamic> jsonData) {
    return CartModel(
      productId: jsonData['productId'],
      productQuantity: jsonData['productQuantity'],
    );
  }

  static Map<String, dynamic> toMap(CartModel music) => {
    'productId': music.productId,
    'productQuantity': music.productQuantity,
  };

  static String encode(List<CartModel> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => CartModel.toMap(music))
        .toList(),
  );

  static List<CartModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<CartModel>((item) => CartModel.fromJson(item))
          .toList();
}