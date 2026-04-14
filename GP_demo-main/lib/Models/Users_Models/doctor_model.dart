import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';

class Doctor extends HealthcareProvider {
  @override
  final String id;
  @override
  final String name;
  final String specialty;
  final String title;
  final String address;
  final double fee;
  @override
  final double rating;
  @override
  final int ratingsCount;
  final bool allowHome;
  final bool allowOnline;
  @override
  final String profilePictureUrl;

  // تطبيق الـ Interface (Mapping)
  @override
  String get subTitle => "$specialty - $title";
  @override
  String get location => address;
  @override
  double get mainFee => fee;
  @override
  String get providerType => "Doctor";

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.title,
    required this.address,
    required this.fee,
    required this.rating,
    required this.ratingsCount,
    required this.allowHome,
    required this.allowOnline,
    required this.profilePictureUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      fee: (json['fee'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      ratingsCount: json['ratingsCount'] ?? 0,
      allowHome: json['allowHome'] ?? false,
      allowOnline: json['allowOnline'] ?? false,
      profilePictureUrl: json['profilePictureUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'title': title,
    'address': address,
    'fee': fee,
    'rating': rating,
    'ratingsCount': ratingsCount,
    'allowHome': allowHome,
    'allowOnline': allowOnline,
    'profilePictureUrl': profilePictureUrl,
  };
}
