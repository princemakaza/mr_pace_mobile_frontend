import 'dart:convert';

class TrainingProgramPackage {
    final String? id;
    final String? title;
    final String? description;
    final String? coverImage;
    final int? durationInWeeks;
    final List<DailyTraining>? dailyTrainings;
    final String? targetRaceType;
    final DateTime? startDate;
    final DateTime? endDate;
    final double? price;
    final double? regularPrice;
    final String? difficultyLevel;
    final String? coachBiography;
    final Coach? coach;
    final List<String>? galleryImages;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    TrainingProgramPackage({
        this.id,
        this.title,
        this.description,
        this.coverImage,
        this.durationInWeeks,
        this.dailyTrainings,
        this.targetRaceType,
        this.startDate,
        this.endDate,
        this.price,
        this.regularPrice,
        this.difficultyLevel,
        this.coachBiography,
        this.coach,
        this.galleryImages,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory TrainingProgramPackage.fromJson(String str) => TrainingProgramPackage.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TrainingProgramPackage.fromMap(Map<String, dynamic> json) => TrainingProgramPackage(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        coverImage: json["coverImage"],
        durationInWeeks: json["durationInWeeks"],
        dailyTrainings: json["dailyTrainings"] == null ? [] : List<DailyTraining>.from(json["dailyTrainings"]!.map((x) => DailyTraining.fromMap(x))),
        targetRaceType: json["targetRaceType"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        price: json["price"]?.toDouble(),
        regularPrice: json["regularPrice"]?.toDouble(),
        difficultyLevel: json["difficultyLevel"],
        coachBiography: json["coachBiography"],
        coach: json["coach"] == null ? null : Coach.fromMap(json["coach"]),
        galleryImages: json["galleryImages"] == null ? [] : List<String>.from(json["galleryImages"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "description": description,
        "coverImage": coverImage,
        "durationInWeeks": durationInWeeks,
        "dailyTrainings": dailyTrainings == null ? [] : List<dynamic>.from(dailyTrainings!.map((x) => x.toMap())),
        "targetRaceType": targetRaceType,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "price": price,
        "regularPrice": regularPrice,
        "difficultyLevel": difficultyLevel,
        "coachBiography": coachBiography,
        "coach": coach?.toMap(),
        "galleryImages": galleryImages == null ? [] : List<dynamic>.from(galleryImages!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}

class Coach {
    final String? id;
    final String? userName;
    final String? email;

    Coach({
        this.id,
        this.userName,
        this.email,
    });

    factory Coach.fromJson(String str) => Coach.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Coach.fromMap(Map<String, dynamic> json) => Coach(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "userName": userName,
        "email": email,
    };
}

class DailyTraining {
    final int? dayNumber;
    final DateTime? date;
    final String? title;
    final String? description;
    final String? workoutPlan;
    final int? durationInMinutes;
    final String? intensityLevel;
    final List<String>? images;
    final String? notes;
    final bool? isRestDay;
    final String? id;

    DailyTraining({
        this.dayNumber,
        this.date,
        this.title,
        this.description,
        this.workoutPlan,
        this.durationInMinutes,
        this.intensityLevel,
        this.images,
        this.notes,
        this.isRestDay,
        this.id,
    });

    factory DailyTraining.fromJson(String str) => DailyTraining.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DailyTraining.fromMap(Map<String, dynamic> json) => DailyTraining(
        dayNumber: json["dayNumber"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        title: json["title"],
        description: json["description"],
        workoutPlan: json["workoutPlan"],
        durationInMinutes: json["durationInMinutes"],
        intensityLevel: json["intensityLevel"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        notes: json["notes"],
        isRestDay: json["isRestDay"],
        id: json["_id"],
    );

    Map<String, dynamic> toMap() => {
        "dayNumber": dayNumber,
        "date": date?.toIso8601String(),
        "title": title,
        "description": description,
        "workoutPlan": workoutPlan,
        "durationInMinutes": durationInMinutes,
        "intensityLevel": intensityLevel,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "notes": notes,
        "isRestDay": isRestDay,
        "_id": id,
    };
}
