enum CleanerJobStatus {
  incoming,
  accepted,
  heading,
  working,
  done,
  cancelled,
}

extension CleanerJobStatusX on CleanerJobStatus {
  String get label {
    switch (this) {
      case CleanerJobStatus.incoming:
        return 'Pesanan Masuk';
      case CleanerJobStatus.accepted:
        return 'Diterima';
      case CleanerJobStatus.heading:
        return 'Menuju Lokasi';
      case CleanerJobStatus.working:
        return 'Sedang Bekerja';
      case CleanerJobStatus.done:
        return 'Selesai';
      case CleanerJobStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  String get nextActionLabel {
    switch (this) {
      case CleanerJobStatus.incoming:
        return 'Terima Pesanan';
      case CleanerJobStatus.accepted:
        return 'Menuju Lokasi';
      case CleanerJobStatus.heading:
        return 'Mulai Bekerja';
      case CleanerJobStatus.working:
        return 'Selesai';
      case CleanerJobStatus.done:
        return 'Selesai';
      case CleanerJobStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}

class CleanerChecklistItem {
  final String title;
  final bool isDone;

  const CleanerChecklistItem({required this.title, this.isDone = false});

  CleanerChecklistItem copyWith({String? title, bool? isDone}) {
    return CleanerChecklistItem(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

class CleanerJobModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String address;
  final String serviceType;
  final String roomDetails; // e.g. "2 Kamar Tidur, 1 Kamar Mandi"
  final String specialNotes;
  final DateTime scheduledAt;
  final int durationMinutes;
  final double distanceKm;
  final double estimatedEarnings;
  final CleanerJobStatus status;
  final List<CleanerChecklistItem> checklistItems;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final double tipAmount;

  const CleanerJobModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.serviceType,
    required this.roomDetails,
    this.specialNotes = '',
    required this.scheduledAt,
    required this.durationMinutes,
    required this.distanceKm,
    required this.estimatedEarnings,
    this.status = CleanerJobStatus.incoming,
    this.checklistItems = const [],
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    this.tipAmount = 0,
  });

  CleanerJobModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? address,
    String? serviceType,
    String? roomDetails,
    String? specialNotes,
    DateTime? scheduledAt,
    int? durationMinutes,
    double? distanceKm,
    double? estimatedEarnings,
    CleanerJobStatus? status,
    List<CleanerChecklistItem>? checklistItems,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
    double? tipAmount,
  }) {
    return CleanerJobModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      address: address ?? this.address,
      serviceType: serviceType ?? this.serviceType,
      roomDetails: roomDetails ?? this.roomDetails,
      specialNotes: specialNotes ?? this.specialNotes,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedEarnings: estimatedEarnings ?? this.estimatedEarnings,
      status: status ?? this.status,
      checklistItems: checklistItems ?? this.checklistItems,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      tipAmount: tipAmount ?? this.tipAmount,
    );
  }
}
