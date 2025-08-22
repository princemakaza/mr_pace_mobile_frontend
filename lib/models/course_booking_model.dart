import 'dart:convert';

class CourseBookingModel {
    final String? id;
    final String? userId;
    final CourseId? courseId;
    final String? paymentStatus;
    final String? pollUrl;
    final double? pricePaid;
    final String? attendanceStatus;
    final DateTime? bookedAt;
    final int? v;

    CourseBookingModel({
        this.id,
        this.userId,
        this.courseId,
        this.paymentStatus,
        this.pollUrl,
        this.pricePaid,
        this.attendanceStatus,
        this.bookedAt,
        this.v,
    });

    factory CourseBookingModel.fromJson(String str) => CourseBookingModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CourseBookingModel.fromMap(Map<String, dynamic> json) => CourseBookingModel(
        id: json["_id"],
        userId: json["userId"],
        courseId: json["courseId"] == null ? null : CourseId.fromMap(json["courseId"]),
        paymentStatus: json["paymentStatus"],
        pollUrl: json["pollUrl"],
        pricePaid: json["pricePaid"]?.toDouble(),
        attendanceStatus: json["attendanceStatus"],
        bookedAt: json["bookedAt"] == null ? null : DateTime.parse(json["bookedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "userId": userId,
        "courseId": courseId?.toMap(),
        "paymentStatus": paymentStatus,
        "pollUrl": pollUrl,
        "pricePaid": pricePaid,
        "attendanceStatus": attendanceStatus,
        "bookedAt": bookedAt?.toIso8601String(),
        "__v": v,
    };
}

class CourseId {
    final String? id;
    final String? title;
    final String? description;
    final String? coach;
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

    CourseId({
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

    factory CourseId.fromJson(String str) => CourseId.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CourseId.fromMap(Map<String, dynamic> json) => CourseId(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        coach: json["coach"],
        coverImage: json["coverImage"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        durationInHours: json["durationInHours"],
        capacity: json["capacity"],
        location: json["location"],
        platformLink: json["platformLink"],
        price: json["price"]?.toDouble(),
        regularPrice: json["regularPrice"]?.toDouble(),
        difficultyLevel: json["difficultyLevel"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "description": description,
        "coach": coach,
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
