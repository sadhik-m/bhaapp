class AddressModel {
  String name;
  String mobile;
  String email;
  String country;
  String address;
  String type;
  String id;
  String pinCode;
  String latitude;
  String longitude;


  AddressModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.country,
    required this.address,
    required this.type,
    required this.id,
    required this.pinCode,
    required this.latitude,
    required this.longitude,

  });

  dynamic toJson() => {
    'name': name,
    'mobile': mobile,
    'email': email,
    'country': country,
    'address': address,
    'type': type,
    'id': id,
    'pinCode': pinCode,
    'latitude': latitude,
    'longitude': longitude,

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
      pinCode: json['pinCode'],
      latitude: json['latitude'],
      longitude: json['longitude'],

    );
  }
}