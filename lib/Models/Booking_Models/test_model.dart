import 'package:equatable/equatable.dart';

class Test extends Equatable {
  final String id;
  final String name;
  final String description;
  final String preRequisites;
  final double? price;
  final bool? isAvailableAtHome;

  const Test({
    this.price,
    this.isAvailableAtHome,
    required this.id,
    required this.name,
    required this.description,
    required this.preRequisites,
  });

  // Equatable هو اللي هيعمل المقارنة والـ hashCode بدالك
  @override
  List<Object?> get props => [id]; // لو الـ id متطابق، الموديل كله متطابق

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      preRequisites: json['preRequisites'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isAvailableAtHome: json['isAvailableAtHome'] ?? false,
    );
  }
}
