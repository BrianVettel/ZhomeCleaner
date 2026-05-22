class CleanerAccountModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final bool isAvailable;
  final double rating;
  final int totalJobsCompleted;
  final double totalEarnings;
  final double walletBalance;
  final String bankAccountNumber;
  final String eWalletNumber;
  final List<int> workingDays; // 1=Mon..7=Sun
  final DateTime registeredAt;
  final String area;

  const CleanerAccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl = '',
    this.isAvailable = true,
    this.rating = 5.0,
    this.totalJobsCompleted = 0,
    this.totalEarnings = 0,
    this.walletBalance = 0,
    this.bankAccountNumber = '',
    this.eWalletNumber = '',
    this.workingDays = const [1, 2, 3, 4, 5],
    required this.registeredAt,
    this.area = 'Jakarta',
  });

  CleanerAccountModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    bool? isAvailable,
    double? rating,
    int? totalJobsCompleted,
    double? totalEarnings,
    double? walletBalance,
    String? bankAccountNumber,
    String? eWalletNumber,
    List<int>? workingDays,
    DateTime? registeredAt,
    String? area,
  }) {
    return CleanerAccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      totalJobsCompleted: totalJobsCompleted ?? this.totalJobsCompleted,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      walletBalance: walletBalance ?? this.walletBalance,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      eWalletNumber: eWalletNumber ?? this.eWalletNumber,
      workingDays: workingDays ?? this.workingDays,
      registeredAt: registeredAt ?? this.registeredAt,
      area: area ?? this.area,
    );
  }
}
