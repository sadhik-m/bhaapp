class AddressModel {
  String name;
  String mobile;
  String email;
  String country;
  String address;
  String type;
  String id;


  AddressModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.country,
    required this.address,
    required this.type,
    required this.id,

  });

  dynamic toJson() => {
    'name': name,
    'mobile': mobile,
    'email': email,
    'country': country,
    'address': address,
    'type': type,
    'id': id,

  };

  factory AddressModel.fromJson(Map json) {
    return AddressModel(
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      country: json['country'],
      address: json['address'],
      type: json['type'],
      id: json['id'],

    );
  }
}