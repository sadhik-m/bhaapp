class OrderStatusModel {
  String name;
  bool status;
  String date;
  String image;

  OrderStatusModel({
    required this.name,
    required this.status,
    required this.date,
    required this.image,
  });

  dynamic toJson() => {
    'name': name,
    'status': status,
    'date': date,
    'image': image,
  };

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      name: json['name'],
      status: json['status'],
      date: json['date'],
      image: json['image'],
    );
  }

}