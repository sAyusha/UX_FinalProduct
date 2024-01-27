import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable{
  final String? orderId;
  final String? artId;
  final String? userId;
  final List<OrderItem> orderItems;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  // final PaymentResult paymentResult;
  final double bidAmount;
  final double shippingPrice;
  final double totalAmount;
  final String? bidStatus;
  // final bool? isPaid;
  // final DateTime paidAt;
  // final bool? isDelivered;
  // final DateTime deliveredAt;
  // final String? userId;

  const OrderEntity({
    this.orderId,
    this.artId,
    this.userId,
    required this.orderItems,
    required this.shippingAddress,
    required this.paymentMethod,
    // required this.paymentResult,
    required this.bidAmount,
    required this.shippingPrice,
    required this.totalAmount,
    this.bidStatus,
    // required this.isPaid,
    // required this.paidAt,
    // required this.isDelivered,
    // required this.deliveredAt,
    // this.userId,
  });

  // empty constructor
  static final empty = OrderEntity(
    orderItems: const [],
    shippingAddress: ShippingAddress.empty(),
    paymentMethod: '',
    // paymentResult: PaymentResult.empty,
    bidAmount: 0,
    shippingPrice: 0,
    totalAmount: 0,
    bidStatus: '',
    // isPaid: false,
    // paidAt: DateTime.now(),
    // isDelivered: false,
    // deliveredAt: DateTime.now(),
  );

  // from JSON
  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      orderId: json['_id'],
      artId: json['artId'],
      userId: json['userId'] ?? "",
      orderItems: (json['orderItems'] as List<dynamic>).map((item) => OrderItem.fromJson(item)).toList(),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      paymentMethod: json['paymentMethod'],
      // paymentResult: PaymentResult.fromJson(json['paymentResult']),
      bidAmount: json['bidAmount'],
      shippingPrice: json['shippingPrice'],
      totalAmount: json['totalAmount'],
      bidStatus: json['bidStatus'] ?? "",

      // isPaid: json['isPaid'],
      // paidAt: DateTime.parse(json['paidAt']),
      // isDelivered: json['isDelivered'],
      // deliveredAt: DateTime.parse(json['deliveredAt']),
      // userId: json['_id'],
    );
  }

  //To JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'artId': artId,
      'userId': userId ?? "",
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      // 'paymentResult': paymentResult.toJson(),
      'bidAmount': bidAmount,
      'shippingPrice': shippingPrice,
      'totalAmount': totalAmount,
      'bidStatus': bidStatus ?? "",
      // 'isPaid': isPaid,
      // 'paidAt': paidAt.toIso8601String(),
      // 'isDelivered': isDelivered,
      // 'deliveredAt': deliveredAt.toIso8601String(),
    };
  }

  //to string
  @override
  String toString() =>
      'OrderEntity {orderId: $orderId, artId: $artId, userId: $userId, orderItems: $orderItems, shippingAddress: $shippingAddress, paymentMethod: $paymentMethod, bidAmount: $bidAmount, shippingPrice: $shippingPrice, totalAmount: $totalAmount, bidStatus: $bidStatus}';
  
  @override
  List<Object?> get props => [
    orderId,
    artId,
    userId,
    orderItems,
    shippingAddress,
    paymentMethod,
    // paymentResult,
    bidAmount,
    shippingPrice,
    totalAmount,
    bidStatus,
    // isPaid,
    // paidAt,
    // isDelivered,
    // deliveredAt,
  ];
}

class OrderItem extends Equatable {
  final String image;
  final String title;
  final String description;
  final String? artId;

  const OrderItem({
    required this.image,
    required this.title,
    required this.description,
    this.artId,
  });

  // from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      image: json['image'],
      title: json['title'],
      description: json['description'],
      artId: json['_id'],
    );
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'art': artId,
    };
  }

  // empty order item
  static OrderItem empty() {
    return const OrderItem(
      image: '',
      title: '',
      description: '',
      artId: '',
    );
  }

  // to string
  @override
  String toString() =>
      'OrderItem { image: $image, title: $title, description: $description, artId: $artId }';
  
  @override
  List<Object?> get props => [
    image,
    title,
    description,
    artId,
  ];
}

class ShippingAddress extends Equatable {
  final String fullname;
  final String address;
  final String postalCode;
  final String city;
  final String request;

  const ShippingAddress({
    required this.fullname,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.request,
  });

  // empty shipping address
  static ShippingAddress empty() {
    return const ShippingAddress(
      fullname: '',
      address: '',
      postalCode: '',
      city: '',
      request: '',
    );
  }
  
  // from JSON
  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullname: json['fullname'],
      address: json['address'],
      postalCode: json['postalCode'],
      city: json['city'],
      request: json['request'],
    );
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'address': address,
      'postalCode': postalCode,
      'city': city,
      'request': request,
    };
  }

  // to string
  @override
  String toString() =>
      'ShippingAddress { fullname: $fullname, address: $address, postalCode: $postalCode, city: $city, request: $request }';

  @override
  List<Object?> get props => [
    fullname,
    address,
    postalCode,
    city,
    request,
  ];
}

// class PaymentResult extends Equatable {
//   final String? id;
//   final String status;
//   final String updateTime;
//   final String emailAddress;

//   const PaymentResult({
//     this.id,
//     required this.status,
//     required this.updateTime,
//     required this.emailAddress,
//   });

//   // empty payment result
//   static PaymentResult empty() {
//     return const PaymentResult(
//       id: '',
//       status: '',
//       updateTime: '',
//       emailAddress: '',
//     );
//   }

//   // from JSON
//   factory PaymentResult.fromJson(Map<String, dynamic> json) {
//     return PaymentResult(
//       id: json['id'],
//       status: json['status'],
//       updateTime: json['updateTime'],
//       emailAddress: json['emailAddress'],
//     );
//   }

//   // to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'status': status,
//       'updateTime': updateTime,
//       'emailAddress': emailAddress,
//     };
//   }

//   // to string
//   @override
//   String toString() =>
//       'PaymentResult { id: $id, status: $status, updateTime: $updateTime, emailAddress: $emailAddress }';
  
//   @override
//   List<Object?> get props => [
//     id,
//     status,
//     updateTime,
//     emailAddress,
//   ];
// }
