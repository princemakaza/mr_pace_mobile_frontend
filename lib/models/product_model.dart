import 'dart:convert';

class ProductModel {
    final String? id;
    final String? name;
    final String? category;
    final String? description;
    final List<String>? images;
    final double? price;
    final double? regularPrice;
    final int? stockQuantity;
    final String? brand;
    final List<String>? sizeOptions;
    final List<String>? colorOptions;
    final List<String>? tags;
    final double? rating;
    final bool? isFeatured;
    final DateTime? createdAt;
    final int? v;

    ProductModel({
        this.id,
        this.name,
        this.category,
        this.description,
        this.images,
        this.price,
        this.regularPrice,
        this.stockQuantity,
        this.brand,
        this.sizeOptions,
        this.colorOptions,
        this.tags,
        this.rating,
        this.isFeatured,
        this.createdAt,
        this.v,
    });

    factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        name: json["name"],
        category: json["category"],
        description: json["description"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        price: json["price"]?.toDouble(),
        regularPrice: json["regularPrice"]?.toDouble(),
        stockQuantity: json["stockQuantity"],
        brand: json["brand"],
        sizeOptions: json["sizeOptions"] == null ? [] : List<String>.from(json["sizeOptions"]!.map((x) => x)),
        colorOptions: json["colorOptions"] == null ? [] : List<String>.from(json["colorOptions"]!.map((x) => x)),
        tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
        rating: json["rating"]?.toDouble(),
        isFeatured: json["isFeatured"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "category": category,
        "description": description,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "price": price,
        "regularPrice": regularPrice,
        "stockQuantity": stockQuantity,
        "brand": brand,
        "sizeOptions": sizeOptions == null ? [] : List<dynamic>.from(sizeOptions!.map((x) => x)),
        "colorOptions": colorOptions == null ? [] : List<dynamic>.from(colorOptions!.map((x) => x)),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "rating": rating,
        "isFeatured": isFeatured,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
    };
}
