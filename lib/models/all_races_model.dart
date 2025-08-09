import 'dart:convert';

class AllRacesModel {
    final String? id;
    final String? name;
    final String? description;
    final String? image;
    final String? registrationPrice;
    final String? venue;
    final String? registrationStatus;
    final DateTime? date;
    final List<RaceEvent>? raceEvents;
    final int? v;

    AllRacesModel({
        this.id,
        this.name,
        this.description,
        this.image,
        this.registrationPrice,
        this.venue,
        this.registrationStatus,
        this.date,
        this.raceEvents,
        this.v,
    });

    factory AllRacesModel.fromJson(String str) => AllRacesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AllRacesModel.fromMap(Map<String, dynamic> json) => AllRacesModel(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        image: json["Image"],
        registrationPrice: json["registrationPrice"],
        venue: json["venue"],
        registrationStatus: json["RegistrationStatus"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        raceEvents: json["raceEvents"] == null ? [] : List<RaceEvent>.from(json["raceEvents"]!.map((x) => RaceEvent.fromMap(x))),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "description": description,
        "Image": image,
        "registrationPrice": registrationPrice,
        "venue": venue,
        "RegistrationStatus": registrationStatus,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "raceEvents": raceEvents == null ? [] : List<dynamic>.from(raceEvents!.map((x) => x.toMap())),
        "__v": v,
    };
}

class RaceEvent {
    final String? distanceRace;
    final String? reachLimit;
    final String? id;

    RaceEvent({
        this.distanceRace,
        this.reachLimit,
        this.id,
    });

    factory RaceEvent.fromJson(String str) => RaceEvent.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RaceEvent.fromMap(Map<String, dynamic> json) => RaceEvent(
        distanceRace: json["distanceRace"],
        reachLimit: json["reachLimit"],
        id: json["_id"],
    );

    Map<String, dynamic> toMap() => {
        "distanceRace": distanceRace,
        "reachLimit": reachLimit,
        "_id": id,
    };
}
