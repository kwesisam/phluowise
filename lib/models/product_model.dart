class Product {
  final String id;                 
  final String productId;          
  final String size;
  final int quantity;
  final String productName;
  final double price;
  final String productType;
  final String? discount;
  final String currency;
  final String companyId;
  final String branchId;
  final bool deliveryCharge;
  final String productImage;

  final String createdAt;          
  final String updatedAt;          
  final int sequence;              

  Product({
    required this.id,
    required this.productId,
    required this.size,
    required this.quantity,
    required this.productName,
    required this.price,
    required this.productType,
    this.discount,
    required this.currency,
    required this.companyId,
    required this.branchId,
    required this.deliveryCharge,
    required this.productImage,
    required this.createdAt,
    required this.updatedAt,
    required this.sequence,
  });


  Product copyWith({
    String? id,
    String? productId,
    String? size,
    int? quantity,
    String? productName,
    double? price,
    String? productType,
    String? discount,
    String? currency,
    String? companyId,
    String? branchId,
    bool? deliveryCharge,
    String? productImage,
    String? createdAt,
    String? updatedAt,
    int? sequence,
  }) {
    return Product(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      productType: productType ?? this.productType,
      discount: discount ?? this.discount,
      currency: currency ?? this.currency,
      companyId: companyId ?? this.companyId,
      branchId: branchId ?? this.branchId,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      productImage: productImage ?? this.productImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sequence: sequence ?? this.sequence,
    );
  }


  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['\$id'] ?? '',
      productId: map['product_id'] ?? '',
      size: map['size'] ?? '',
      quantity: map['quantity'] is int
          ? map['quantity']
          : int.tryParse(map['quantity'].toString()) ?? 0,
      productName: map['product_name'] ?? '',
      price: map['price'] is num
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price'].toString()) ?? 0.0,
      productType: map['product_type'] ?? '',
      discount: map['discount']?.toString(),
      currency: map['currency'] ?? '',
      companyId: map['company_id'] ?? '',
      branchId: map['branch_id'] ?? '',
      deliveryCharge: map['delivery_charge'] ?? false,
      productImage: map['product_image'] ?? '',
      createdAt: map['\$createdAt'] ?? '',
      updatedAt: map['\$updatedAt'] ?? '',
      sequence: map['\$sequence'] is int
          ? map['\$sequence']
          : int.tryParse(map['\$sequence'].toString()) ?? 0,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      '\$id': id,
      'product_id': productId,
      'size': size,
      'quantity': quantity,
      'product_name': productName,
      'price': price,
      'product_type': productType,
      'discount': discount,
      'currency': currency,
      'company_id': companyId,
      'branch_id': branchId,
      'delivery_charge': deliveryCharge,
      'product_image': productImage,
      '\$createdAt': createdAt,
      '\$updatedAt': updatedAt,
      '\$sequence': sequence,
    };
  }
}
