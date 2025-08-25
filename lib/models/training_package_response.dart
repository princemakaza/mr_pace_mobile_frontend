import 'dart:convert';

class TrainingPackageResponseModel {
  final String? userId;
  final String? trainingProgramPackageId;
  final String? paymentStatus;
  final String? pollUrl;
  final double? pricePaid;
  final DateTime? boughtAt;
  final String? id;
  final int? v;

  TrainingPackageResponseModel({
    this.userId,
    this.trainingProgramPackageId,
    this.paymentStatus,
    this.pollUrl,
    this.pricePaid,
    this.boughtAt,
    this.id,
    this.v,
  });

  factory TrainingPackageResponseModel.fromJson(String str) =>
      TrainingPackageResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrainingPackageResponseModel.fromMap(Map<String, dynamic> json) =>
      TrainingPackageResponseModel(
        userId: json["userId"],
        trainingProgramPackageId: json["training_program_package_id"],
        paymentStatus: json["paymentStatus"],
        pollUrl: json["pollUrl"],
        pricePaid: json["pricePaid"]?.toDouble(),
        boughtAt: json["boughtAt"] == null
            ? null
            : DateTime.parse(json["boughtAt"]),
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "training_program_package_id": trainingProgramPackageId,
    "paymentStatus": paymentStatus,
    "pollUrl": pollUrl,
    "pricePaid": pricePaid,
    "boughtAt": boughtAt?.toIso8601String(),
    "_id": id,
    "__v": v,
  };
}
