import 'dart:convert';

class TrainingPackageBoughtModel {
  final String? id;
  final String? userId;
  final TrainingProgramPackageId? trainingProgramPackageId;
  final String? paymentStatus;
  final String? pollUrl;
  final double? pricePaid;
  final DateTime? boughtAt;
  final int? v;

  TrainingPackageBoughtModel({
    this.id,
    this.userId,
    this.trainingProgramPackageId,
    this.paymentStatus,
    this.pollUrl,
    this.pricePaid,
    this.boughtAt,
    this.v,
  });

  factory TrainingPackageBoughtModel.fromJson(String str) =>
      TrainingPackageBoughtModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrainingPackageBoughtModel.fromMap(Map<String, dynamic> json) =>
      TrainingPackageBoughtModel(
        id: json["_id"],
        userId: json["userId"],
        trainingProgramPackageId: json["training_program_package_id"] == null
            ? null
            : TrainingProgramPackageId.fromMap(
                json["training_program_package_id"],
              ),
        paymentStatus: json["paymentStatus"],
        pollUrl: json["pollUrl"],
        pricePaid: json["pricePaid"]?.toDouble(),
        boughtAt: json["boughtAt"] == null
            ? null
            : DateTime.parse(json["boughtAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userId": userId,
    "training_program_package_id": trainingProgramPackageId?.toMap(),
    "paymentStatus": paymentStatus,
    "pollUrl": pollUrl,
    "pricePaid": pricePaid,
    "boughtAt": boughtAt?.toIso8601String(),
    "__v": v,
  };
}

class TrainingProgramPackageId {
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
  final String? coach;
  final List<String>? galleryImages;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  TrainingProgramPackageId({
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

  factory TrainingProgramPackageId.fromJson(String str) =>
      TrainingProgramPackageId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrainingProgramPackageId.fromMap(Map<String, dynamic> json) =>
      TrainingProgramPackageId(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        coverImage: json["coverImage"],
        durationInWeeks: json["durationInWeeks"],
        dailyTrainings: json["dailyTrainings"] == null
            ? []
            : List<DailyTraining>.from(
                json["dailyTrainings"]!.map((x) => DailyTraining.fromMap(x)),
              ),
        targetRaceType: json["targetRaceType"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null
            ? null
            : DateTime.parse(json["endDate"]),
        price: json["price"]?.toDouble(),
        regularPrice: json["regularPrice"]?.toDouble(),
        difficultyLevel: json["difficultyLevel"],
        coachBiography: json["coachBiography"],
        coach: json["coach"],
        galleryImages: json["galleryImages"] == null
            ? []
            : List<String>.from(json["galleryImages"]!.map((x) => x)),
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
    "coverImage": coverImage,
    "durationInWeeks": durationInWeeks,
    "dailyTrainings": dailyTrainings == null
        ? []
        : List<dynamic>.from(dailyTrainings!.map((x) => x.toMap())),
    "targetRaceType": targetRaceType,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "price": price,
    "regularPrice": regularPrice,
    "difficultyLevel": difficultyLevel,
    "coachBiography": coachBiography,
    "coach": coach,
    "galleryImages": galleryImages == null
        ? []
        : List<dynamic>.from(galleryImages!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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

  factory DailyTraining.fromJson(String str) =>
      DailyTraining.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyTraining.fromMap(Map<String, dynamic> json) => DailyTraining(
    dayNumber: json["dayNumber"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    title: json["title"],
    description: json["description"],
    workoutPlan: json["workoutPlan"],
    durationInMinutes: json["durationInMinutes"],
    intensityLevel: json["intensityLevel"],
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"]!.map((x) => x)),
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
