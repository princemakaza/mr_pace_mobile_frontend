// models/submit_registration_model.dart
class SubmitRegistrationModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String race;
  final String raceName;
  final int racePrice;
  final String raceEvent;
  final String dateOfBirth;
  final String nationalId;
  final String gender;
  final String phoneNumber;
  final String email;
  final String tShirtSize;

  SubmitRegistrationModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.race,
    required this.raceName,
    required this.racePrice,
    required this.raceEvent,
    required this.dateOfBirth,
    required this.nationalId,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.tShirtSize,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "race": race,
      "raceName": raceName,
      "racePrice": racePrice,
      "raceEvent": raceEvent,
      "dateOfBirth": dateOfBirth,
      "nationalID": nationalId,
      "Gender": gender,
      "phoneNumber": phoneNumber,
      "email": email,
      "t_shirt_size": tShirtSize,
    };
  }
}
