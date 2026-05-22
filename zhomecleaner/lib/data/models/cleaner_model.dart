class CleanerModel {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int totalJobs;
  final int experienceYears;
  final bool isAvailable;
  final List<String> specializations;
  final String bio;

  const CleanerModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.totalJobs,
    required this.experienceYears,
    required this.isAvailable,
    required this.specializations,
    this.bio = '',
  });
}
