import 'dart:convert';

class AllOrderModel {
  final DeliveryCoordinates? deliveryCoordinates;
  final String? id;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? shippingAddress;
  final String? pollUrl;
  final String? adminComment;
  final bool? needsDelivery;
  final int? deliveryFee;
  final List<Product>? products;
  final double? totalAmount;
  final String? paymentOption;
  final String? paymentStatus;
  final String? orderStatus;
  final DateTime? createdAt;
  final int? v;

  AllOrderModel({
    this.deliveryCoordinates,
    this.id,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.shippingAddress,
    this.pollUrl,
    this.adminComment,
    this.needsDelivery,
    this.deliveryFee,
    this.products,
    this.totalAmount,
    this.paymentOption,
    this.paymentStatus,
    this.orderStatus,
    this.createdAt,
    this.v,
  });

  factory AllOrderModel.fromJson(String str) =>
      AllOrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AllOrderModel.fromMap(Map<String, dynamic> json) => AllOrderModel(
    deliveryCoordinates: json["deliveryCoordinates"] == null
        ? null
        : DeliveryCoordinates.fromMap(json["deliveryCoordinates"]),
    id: json["_id"],
    customerName: json["customerName"],
    customerEmail: json["customerEmail"],
    customerPhone: json["customerPhone"],
    shippingAddress: json["shippingAddress"],
    pollUrl: json["pollUrl"],
    adminComment: json["adminComment"],
    needsDelivery: json["needsDelivery"],
    deliveryFee: json["deliveryFee"],
    products: json["products"] == null
        ? []
        : List<Product>.from(json["products"]!.map((x) => Product.fromMap(x))),
    totalAmount: json["totalAmount"]?.toDouble(),
    paymentOption: json["paymentOption"],
    paymentStatus: json["paymentStatus"],
    orderStatus: json["orderStatus"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toMap() => {
    "deliveryCoordinates": deliveryCoordinates?.toMap(),
    "_id": id,
    "customerName": customerName,
    "customerEmail": customerEmail,
    "customerPhone": customerPhone,
    "shippingAddress": shippingAddress,
    "pollUrl": pollUrl,
    "adminComment": adminComment,
    "needsDelivery": needsDelivery,
    "deliveryFee": deliveryFee,
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toMap())),
    "totalAmount": totalAmount,
    "paymentOption": paymentOption,
    "paymentStatus": paymentStatus,
    "orderStatus": orderStatus,
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}

class DeliveryCoordinates {
  final double? latitude;
  final double? longitude;

  DeliveryCoordinates({this.latitude, this.longitude});

  factory DeliveryCoordinates.fromJson(String str) =>
      DeliveryCoordinates.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeliveryCoordinates.fromMap(Map<String, dynamic> json) =>
      DeliveryCoordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Product {
  final ProductId? productId;
  final String? name;
  final double? price;
  final int? quantity;
  final String? size;
  final String? color;

  Product({
    this.productId,
    this.name,
    this.price,
    this.quantity,
    this.size,
    this.color,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    productId: json["productId"] == null
        ? null
        : ProductId.fromMap(json["productId"]),
    name: json["name"],
    price: json["price"]?.toDouble(),
    quantity: json["quantity"],
    size: json["size"],
    color: json["color"],
  );

  Map<String, dynamic> toMap() => {
    "productId": productId?.toMap(),
    "name": name,
    "price": price,
    "quantity": quantity,
    "size": size,
    "color": color,
  };
}

class ProductId {
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

  ProductId({
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

  factory ProductId.fromJson(String str) => ProductId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductId.fromMap(Map<String, dynamic> json) => ProductId(
    id: json["_id"],
    name: json["name"],
    category: json["category"],
    description: json["description"],
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"]!.map((x) => x)),
    price: json["price"]?.toDouble(),
    regularPrice: json["regularPrice"]?.toDouble(),
    stockQuantity: json["stockQuantity"],
    brand: json["brand"],
    sizeOptions: json["sizeOptions"] == null
        ? []
        : List<String>.from(json["sizeOptions"]!.map((x) => x)),
    colorOptions: json["colorOptions"] == null
        ? []
        : List<String>.from(json["colorOptions"]!.map((x) => x)),
    tags: json["tags"] == null
        ? []
        : List<String>.from(json["tags"]!.map((x) => x)),
    rating: json["rating"]?.toDouble(),
    isFeatured: json["isFeatured"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
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
    "sizeOptions": sizeOptions == null
        ? []
        : List<dynamic>.from(sizeOptions!.map((x) => x)),
    "colorOptions": colorOptions == null
        ? []
        : List<dynamic>.from(colorOptions!.map((x) => x)),
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "rating": rating,
    "isFeatured": isFeatured,
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}
