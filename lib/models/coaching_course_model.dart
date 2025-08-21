import 'dart:convert';

class CoachingCourseModel {
  final String? id;
  final String? title;
  final String? description;
  final Coach? coach;
  final String? coverImage;
  final DateTime? date;
  final int? durationInHours;
  final int? capacity;
  final String? location;
  final String? platformLink;
  final double? price;
  final double? regularPrice;
  final String? difficultyLevel;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  CoachingCourseModel({
    this.id,
    this.title,
    this.description,
    this.coach,
    this.coverImage,
    this.date,
    this.durationInHours,
    this.capacity,
    this.location,
    this.platformLink,
    this.price,
    this.regularPrice,
    this.difficultyLevel,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CoachingCourseModel.fromJson(String str) =>
      CoachingCourseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CoachingCourseModel.fromMap(Map<String, dynamic> json) =>
      CoachingCourseModel(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        coach: json["coach"] == null ? null : Coach.fromMap(json["coach"]),
        coverImage: json["coverImage"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        durationInHours: json["durationInHours"],
        capacity: json["capacity"],
        location: json["location"],
        platformLink: json["platformLink"],
        price: json["price"]?.toDouble(),
        regularPrice: json["regularPrice"]?.toDouble(),
        difficultyLevel: json["difficultyLevel"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "title": title,
    "description": description,
    "coach": coach?.toMap(),
    "coverImage": coverImage,
    "date": date?.toIso8601String(),
    "durationInHours": durationInHours,
    "capacity": capacity,
    "location": location,
    "platformLink": platformLink,
    "price": price,
    "regularPrice": regularPrice,
    "difficultyLevel": difficultyLevel,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Coach {
  final String? id;
  final String? userName;
  final String? email;

  Coach({this.id, this.userName, this.email});

  factory Coach.fromJson(String str) => Coach.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Coach.fromMap(Map<String, dynamic> json) =>
      Coach(id: json["_id"], userName: json["userName"], email: json["email"]);

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userName": userName,
    "email": email,
  };
}
