import 'package:flutter/material.dart';
import '../models/cleaner_job_model.dart';

class CleanerJobsProvider extends ChangeNotifier {
  // ✅ Data dummy langsung diinisialisasi di sini.
  // Tidak perlu dipanggil dari luar (loadDummyJobs sudah deprecated).
  // Tidak ada risiko null, tidak ada infinite loop.
  late List<CleanerJobModel> _jobs;

  CleanerJobsProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    final now = DateTime.now();
    _jobs = [
      CleanerJobModel(
        id: 'JOB-001',
        customerId: 'u_001',
        customerName: 'Budi Santoso',
        customerPhone: '081234567890',
        address: 'Jl. Sudirman No. 45, Jakarta Selatan',
        serviceType: 'Deep Cleaning Rumah',
        roomDetails: '2 Kamar Tidur, 1 Kamar Mandi, Dapur',
        specialNotes: 'Tolong jangan gunakan bahan kimia keras di lantai kayu.',
        scheduledAt: now.add(const Duration(hours: 1)),
        durationMinutes: 180,
        distanceKm: 2.4,
        estimatedEarnings: 185000,
        status: CleanerJobStatus.incoming,
        checklistItems: const [
          CleanerChecklistItem(title: 'Sapu & Pel Lantai'),
          CleanerChecklistItem(title: 'Bersihkan Kamar Tidur 1'),
          CleanerChecklistItem(title: 'Bersihkan Kamar Tidur 2'),
          CleanerChecklistItem(title: 'Bersihkan Kamar Mandi'),
          CleanerChecklistItem(title: 'Bersihkan Dapur'),
          CleanerChecklistItem(title: 'Lap Debu Furnitur'),
          CleanerChecklistItem(title: 'Buang Sampah'),
        ],
      ),
      CleanerJobModel(
        id: 'JOB-002',
        customerId: 'u_002',
        customerName: 'Siti Rahma',
        customerPhone: '082198765432',
        address: 'Jl. Kuningan Mulia No. 12, Jakarta Selatan',
        serviceType: 'Cuci Sofa',
        roomDetails: '1 Sofa 3 Dudukan, 2 Bantal Sofa',
        scheduledAt: now.add(const Duration(hours: 3)),
        durationMinutes: 120,
        distanceKm: 5.1,
        estimatedEarnings: 120000,
        status: CleanerJobStatus.incoming,
        checklistItems: const [
          CleanerChecklistItem(title: 'Vakum Sofa'),
          CleanerChecklistItem(title: 'Cuci Kain Sofa'),
          CleanerChecklistItem(title: 'Bersihkan Rangka Sofa'),
          CleanerChecklistItem(title: 'Cuci Bantal Sofa'),
          CleanerChecklistItem(title: 'Keringkan & Rapikan'),
        ],
      ),
      CleanerJobModel(
        id: 'JOB-003',
        customerId: 'u_003',
        customerName: 'Andi Pratama',
        customerPhone: '085312345678',
        address: 'Jl. TB Simatupang No. 8, Jakarta Selatan',
        serviceType: 'Regular Cleaning',
        roomDetails: '3 Kamar Tidur, 2 Kamar Mandi',
        specialNotes: 'Ada anjing peliharaan, tolong hati-hati saat masuk.',
        scheduledAt: now.subtract(const Duration(days: 1)),
        durationMinutes: 150,
        distanceKm: 3.8,
        estimatedEarnings: 150000,
        tipAmount: 25000,
        status: CleanerJobStatus.done,
        checklistItems: const [
          CleanerChecklistItem(title: 'Sapu & Pel Lantai', isDone: true),
          CleanerChecklistItem(title: 'Bersihkan Kamar Tidur 1', isDone: true),
          CleanerChecklistItem(title: 'Bersihkan Kamar Tidur 2', isDone: true),
          CleanerChecklistItem(title: 'Bersihkan Kamar Tidur 3', isDone: true),
          CleanerChecklistItem(title: 'Bersihkan Kamar Mandi 1', isDone: true),
          CleanerChecklistItem(title: 'Bersihkan Kamar Mandi 2', isDone: true),
          CleanerChecklistItem(title: 'Buang Sampah', isDone: true),
        ],
      ),
    ];
  }

  // ─── GETTERS ────────────────────────────────────────────────
  List<CleanerJobModel> get jobs => _jobs;

  List<CleanerJobModel> get incomingJobs =>
      _jobs.where((j) => j.status == CleanerJobStatus.incoming).toList();

  List<CleanerJobModel> get activeJobs => _jobs
      .where((j) =>
          j.status == CleanerJobStatus.accepted ||
          j.status == CleanerJobStatus.heading ||
          j.status == CleanerJobStatus.working)
      .toList();

  List<CleanerJobModel> get completedJobs =>
      _jobs.where((j) => j.status == CleanerJobStatus.done).toList();

  int get weeklyCompletedCount {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _jobs
        .where((j) =>
            j.status == CleanerJobStatus.done &&
            j.scheduledAt.isAfter(weekStart))
        .length;
  }

  double get todayEstimatedEarnings {
    final today = DateTime.now();
    return _jobs
        .where((j) =>
            j.scheduledAt.day == today.day &&
            j.scheduledAt.month == today.month &&
            j.scheduledAt.year == today.year &&
            j.status != CleanerJobStatus.cancelled)
        .fold(0.0, (sum, j) => sum + j.estimatedEarnings);
  }

  // ─── ACTIONS ────────────────────────────────────────────────

  // Tetap ada untuk kompatibilitas mundur — sekarang hanya reset data.
  void loadDummyJobs() {
    _loadInitialData();
    notifyListeners();
  }

  void acceptJob(String id) => _updateStatus(id, CleanerJobStatus.accepted);

  void updateJobStatus(String id, CleanerJobStatus status) =>
      _updateStatus(id, status);

  void _updateStatus(String id, CleanerJobStatus status) {
    final index = _jobs.indexWhere((j) => j.id == id);
    if (index == -1) return;
    _jobs[index] = _jobs[index].copyWith(status: status);
    notifyListeners();
  }

  void toggleChecklistItem(String jobId, int itemIndex) {
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) return;
    final job = _jobs[index];
    if (itemIndex < 0 || itemIndex >= job.checklistItems.length) return;
    final updatedList = List<CleanerChecklistItem>.from(job.checklistItems);
    updatedList[itemIndex] =
        updatedList[itemIndex].copyWith(isDone: !updatedList[itemIndex].isDone);
    _jobs[index] = job.copyWith(checklistItems: updatedList);
    notifyListeners();
  }

  void addBeforePhoto(String jobId, String path) {
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) return;
    final photos = List<String>.from(_jobs[index].beforePhotos)..add(path);
    _jobs[index] = _jobs[index].copyWith(beforePhotos: photos);
    notifyListeners();
  }

  void addAfterPhoto(String jobId, String path) {
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) return;
    final photos = List<String>.from(_jobs[index].afterPhotos)..add(path);
    _jobs[index] = _jobs[index].copyWith(afterPhotos: photos);
    notifyListeners();
  }

  CleanerJobModel? getJobById(String id) {
    try {
      return _jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }
}
