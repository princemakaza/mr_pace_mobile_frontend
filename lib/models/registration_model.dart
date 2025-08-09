class RegistrationModel {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final dynamic race; // Can be either String (ID) or RaceModel
  final String raceName;
  final int racePrice;
  final String raceEvent;
  final String paymentStatus;
  final String gender;
  final String phoneNumber;
  final String email;
  final String tShirtSize;
  final String registrationNumber;
  final DateTime dateOfBirth;
  final String pollUrl;

  RegistrationModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.race,
    required this.raceName,
    required this.racePrice,
    required this.raceEvent,
    required this.paymentStatus,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.tShirtSize,
    required this.registrationNumber,
    required this.dateOfBirth,
    required this.pollUrl,
  });

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    dynamic raceData;
    if (map['race'] is Map<String, dynamic>) {
      raceData = RaceModel.fromMap(map['race']);
    } else {
      raceData = map['race']?.toString(); // Handle case where it's just an ID
    }

    return RegistrationModel(
      id: map['_id'] ?? '',
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      race: raceData,
      raceName: map['raceName'] ?? '',
      racePrice: map['racePrice'] ?? 0,
      raceEvent: map['raceEvent'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      gender: map['Gender'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      tShirtSize: map['t_shirt_size'] ?? '',
      registrationNumber: map['registration_number'] ?? '',
      dateOfBirth: DateTime.parse(
        map['dateOfBirth'] ?? DateTime.now().toIso8601String(),
      ),
      pollUrl: map['pollUrl'] ?? '',
    );
  }
}

class RaceModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String registrationPrice;
  final String venue;
  final String registrationStatus;
  final String date;

  RaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.registrationPrice,
    required this.venue,
    required this.registrationStatus,
    required this.date,
  });

  factory RaceModel.fromMap(Map<String, dynamic> map) {
    return RaceModel(
      id: map['_id'],
      name: map['name'],
      description: map['description'],
      image: map['Image'],
      registrationPrice: map['registrationPrice'],
      venue: map['venue'],
      registrationStatus: map['RegistrationStatus'],
      date: map['date'],
    );
  }
}
