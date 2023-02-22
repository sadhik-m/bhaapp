class NotificationModel {
  String title;
  String body;



  NotificationModel({
    required this.title,
    required this.body,


  });

  dynamic toJson() => {
    'title': title,
    'body': body,


  };

  factory NotificationModel.fromJson(Map json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],

    );
  }
}