class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isPopular,
  });

  final String id;
  final String name;
  final int price;
  final String period;
  final List<String> features;
  final bool isPopular;

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    int? price,
    String? period,
    List<String>? features,
    bool? isPopular,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      period: period ?? this.period,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      period: json['period'] as String,
      features: (json['features'] as List<dynamic>).cast<String>(),
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'period': period,
      'features': features,
      'isPopular': isPopular,
    };
  }
}
