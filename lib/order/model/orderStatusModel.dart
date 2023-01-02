class OrderStatusModel {
  String name;
  bool status;
  String date;

  OrderStatusModel({
    required this.name,
    required this.status,
    required this.date,
  });

  dynamic toJson() => {
    'name': name,
    'status': status,
    'date': date,
  };

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      name: json['name'],
      status: json['status'],
      date: json['date'],
    );
  }

}