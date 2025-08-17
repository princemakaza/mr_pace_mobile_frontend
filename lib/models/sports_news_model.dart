import 'dart:convert';

class SportNewsModel {
  final String? id;
  final String? title;
  final List<String>? moreImages;
  final String? content;
  final String? category;
  final String? source;
  final String? imageUrl;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  SportNewsModel({
    this.id,
    this.title,
    this.moreImages,
    this.content,
    this.category,
    this.source,
    this.imageUrl,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SportNewsModel.fromJson(String str) =>
      SportNewsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SportNewsModel.fromMap(Map<String, dynamic> json) => SportNewsModel(
    id: json["_id"],
    title: json["title"],
    moreImages: json["moreImages"] == null
        ? []
        : List<String>.from(json["moreImages"]!.map((x) => x)),
    content: json["content"],
    category: json["category"],
    source: json["source"],
    imageUrl: json["imageUrl"],
    publishedAt: json["publishedAt"] == null
        ? null
        : DateTime.parse(json["publishedAt"]),
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
    "moreImages": moreImages == null
        ? []
        : List<dynamic>.from(moreImages!.map((x) => x)),
    "content": content,
    "category": category,
    "source": source,
    "imageUrl": imageUrl,
    "publishedAt": publishedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
