import 'dart:convert';

class ProfileModel {
  final EmergencyContact? emergencyContact;
  final String? id;
  final UserId? userId;
  final String? profilePicture;
  final String? firstName;
  final String? lastName;
  final String? nationalId;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? tShirtSize;
  final String? gender;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ProfileModel({
    this.emergencyContact,
    this.id,
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
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ProfileModel.fromJson(String str) =>
      ProfileModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromMap(Map<String, dynamic> json) => ProfileModel(
    emergencyContact: json["emergencyContact"] == null
        ? null
        : EmergencyContact.fromMap(json["emergencyContact"]),
    id: json["_id"],
    userId: json["userId"] == null ? null : UserId.fromMap(json["userId"]),
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
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toMap() => {
    "emergencyContact": emergencyContact?.toMap(),
    "_id": id,
    "userId": userId?.toMap(),
    "profilePicture": profilePicture,
    "firstName": firstName,
    "lastName": lastName,
    "nationalId": nationalId,
    "phoneNumber": phoneNumber,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "tShirtSize": tShirtSize,
    "gender": gender,
    "address": address,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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

class UserId {
  final String? id;
  final String? userName;
  final String? email;
  final String? password;
  final String? role;
  final int? v;

  UserId({
    this.id,
    this.userName,
    this.email,
    this.password,
    this.role,
    this.v,
  });

  factory UserId.fromJson(String str) => UserId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserId.fromMap(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    v: json["__v"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "userName": userName,
    "email": email,
    "password": password,
    "role": role,
    "__v": v,
  };
}
