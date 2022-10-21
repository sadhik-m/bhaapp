class RatingModel {
  String rating;
  String cid;
  String time;
  String comment;



  RatingModel({
    required this.rating,
    required this.cid,
    required this.time,
    required this.comment,

  });

  dynamic toJson() => {
    'rating': rating,
    'cid': cid,
    'time': time,
    'comment': comment,

  };

  factory RatingModel.fromJson(Map json) {
    return RatingModel(
      rating: json['rating'],
      cid: json['cid'],
      time: json['time'],
      comment: json['comment'],

    );
  }
}