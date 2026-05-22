class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double pricePerUnit;
  final String priceUnit;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final int durationMinutes;
  final List<String> features;
  final bool isPopular;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.pricePerUnit,
    required this.priceUnit,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.durationMinutes,
    this.features = const [],
    this.isPopular = false,
  });
}
