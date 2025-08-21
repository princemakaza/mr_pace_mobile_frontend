import 'dart:convert';

class CreateProfileModel {
  final String? userId;
  final String? profilePicture;
  final String? firstName;
  final String? lastName;
  final String? nationalId;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? tShirtSize;
  final String? gender;
  final String? address;
  final EmergencyContact? emergencyContact;

  CreateProfileModel({
    this.userId,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.nationalId,
    this.phoneNumber,
    this.dateOfBirth,
    this.tShirtSize,
    this.gender,
    this.address,
    this.emergencyContact,
  });

  factory CreateProfileModel.fromJson(String str) =>
      CreateProfileModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateProfileModel.fromMap(Map<String, dynamic> json) =>
      CreateProfileModel(
        userId: json["userId"],
        profilePicture: json["profilePicture"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        nationalId: json["nationalId"],
        phoneNumber: json["phoneNumber"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        tShirtSize: json["tShirtSize"],
        gender: json["gender"],
        address: json["address"],
        emergencyContact: json["emergencyContact"] == null
            ? null
            : EmergencyContact.fromMap(json["emergencyContact"]),
      );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "profilePicture": profilePicture,
    "firstName": firstName,
    "lastName": lastName,
    "nationalId": nationalId,
    "phoneNumber": phoneNumber,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "tShirtSize": tShirtSize,
    "gender": gender,
    "address": address,
    "emergencyContact": emergencyContact?.toMap(),
  };
}

class EmergencyContact {
  final String? name;
  final String? phone;
  final String? relationship;

  EmergencyContact({this.name, this.phone, this.relationship});

  factory EmergencyContact.fromJson(String str) =>
      EmergencyContact.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmergencyContact.fromMap(Map<String, dynamic> json) =>
      EmergencyContact(
        name: json["name"],
        phone: json["phone"],
        relationship: json["relationship"],
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "phone": phone,
    "relationship": relationship,
  };
}
