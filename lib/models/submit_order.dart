import 'dart:convert';

class SubmitOrderModel {
    final String? customerName;
    final String? customerEmail;
    final String? customerPhone;
    final String? shippingAddress;
    final bool? needsDelivery;
    final int? deliveryFee;
    final DeliveryCoordinates? deliveryCoordinates;
    final List<Product>? products;
    final double? totalAmount;
    final String? paymentOption;
    final String? paymentStatus;
    final String? orderStatus;
    final DateTime? createdAt;

    SubmitOrderModel({
        this.customerName,
        this.customerEmail,
        this.customerPhone,
        this.shippingAddress,
        this.needsDelivery,
        this.deliveryFee,
        this.deliveryCoordinates,
        this.products,
        this.totalAmount,
        this.paymentOption,
        this.paymentStatus,
        this.orderStatus,
        this.createdAt,
    });

    factory SubmitOrderModel.fromJson(String str) => SubmitOrderModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SubmitOrderModel.fromMap(Map<String, dynamic> json) => SubmitOrderModel(
        customerName: json["customerName"],
        customerEmail: json["customerEmail"],
        customerPhone: json["customerPhone"],
        shippingAddress: json["shippingAddress"],
        needsDelivery: json["needsDelivery"],
        deliveryFee: json["deliveryFee"],
        deliveryCoordinates: json["deliveryCoordinates"] == null ? null : DeliveryCoordinates.fromMap(json["deliveryCoordinates"]),
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromMap(x))),
        totalAmount: json["totalAmount"]?.toDouble(),
        paymentOption: json["paymentOption"],
        paymentStatus: json["paymentStatus"],
        orderStatus: json["orderStatus"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toMap() => {
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerPhone": customerPhone,
        "shippingAddress": shippingAddress,
        "needsDelivery": needsDelivery,
        "deliveryFee": deliveryFee,
        "deliveryCoordinates": deliveryCoordinates?.toMap(),
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toMap())),
        "totalAmount": totalAmount,
        "paymentOption": paymentOption,
        "paymentStatus": paymentStatus,
        "orderStatus": orderStatus,
        "createdAt": createdAt?.toIso8601String(),
    };
}

class DeliveryCoordinates {
    final double? latitude;
    final double? longitude;

    DeliveryCoordinates({
        this.latitude,
        this.longitude,
    });

    factory DeliveryCoordinates.fromJson(String str) => DeliveryCoordinates.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DeliveryCoordinates.fromMap(Map<String, dynamic> json) => DeliveryCoordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class Product {
    final String? productId;
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
        productId: json["productId"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"],
        size: json["size"],
        color: json["color"],
    );

    Map<String, dynamic> toMap() => {
        "productId": productId,
        "name": name,
        "price": price,
        "quantity": quantity,
        "size": size,
        "color": color,
    };
}
