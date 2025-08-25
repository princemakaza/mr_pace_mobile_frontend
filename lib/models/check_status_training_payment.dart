import 'dart:convert';
class CheckStatusTrainingPaymentModel {
  final String? status;
  final String? message;
  final String? purchaseId;
  final String? pollUrl;

  CheckStatusTrainingPaymentModel({
    this.status,
    this.message,
    this.purchaseId,
    this.pollUrl,
  });

  factory CheckStatusTrainingPaymentModel.fromJson(String str) =>
      CheckStatusTrainingPaymentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CheckStatusTrainingPaymentModel.fromMap(Map<String, dynamic> json) =>
      CheckStatusTrainingPaymentModel(
        status: json["status"],
        message: json["message"],
        purchaseId: json["purchaseId"],
        pollUrl: json["pollUrl"],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "purchaseId": purchaseId,
    "pollUrl": pollUrl,
  };
}
