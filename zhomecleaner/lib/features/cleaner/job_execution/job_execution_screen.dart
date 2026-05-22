import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/cleaner_jobs_provider.dart';
import '../../../data/models/cleaner_job_model.dart';
import '../../../navigation/app_routes.dart';

class JobExecutionScreen extends StatefulWidget {
  final String jobId;

  const JobExecutionScreen({super.key, required this.jobId});

  @override
  State<JobExecutionScreen> createState() => _JobExecutionScreenState();
}

class _JobExecutionScreenState extends State<JobExecutionScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _pickImage(bool isBefore) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && mounted) {
      final provider = context.read<CleanerJobsProvider>();
      if (isBefore) {
        provider.addBeforePhoto(widget.jobId, image.path);
      } else {
        provider.addAfterPhoto(widget.jobId, image.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<CleanerJobsProvider>();
    final job = jobsProvider.getJobById(widget.jobId);

    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Eksekusi Pekerjaan')),
        body: const Center(child: Text('Pesanan tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Sedang Bekerja'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.phone_circle_fill, color: AppColors.statusDone, size: 28),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimerCard(job),
            const SizedBox(height: 16),
            _buildChecklist(job, jobsProvider),
            const SizedBox(height: 16),
            _buildPhotoSection('Foto Sebelum', true, job.beforePhotos),
            const SizedBox(height: 16),
            _buildPhotoSection('Foto Sesudah', false, job.afterPhotos),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(context, job, jobsProvider),
    );
  }

  Widget _buildTimerCard(CleanerJobModel job) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Waktu Pengerjaan',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatTime(_elapsedSeconds),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_elapsedSeconds / 60) / job.durationMinutes,
            backgroundColor: Colors.grey[200],
            color: AppColors.primaryBlue,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 10),
          Text(
            'Target Durasi: ${job.durationMinutes} Menit',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          )
        ],
      ),
    );
  }

  Widget _buildChecklist(CleanerJobModel job, CleanerJobsProvider provider) {
    int completedCount = job.checklistItems.where((item) => item.isDone).length;
    double progress = job.checklistItems.isEmpty ? 0 : completedCount / job.checklistItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Tugas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '$completedCount/${job.checklistItems.length} Selesai',
                style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: AppColors.statusDone,
          ),
          const SizedBox(height: 16),
          ...List.generate(job.checklistItems.length, (index) {
            final item = job.checklistItems[index];
            return CheckboxListTile(
              title: Text(
                item.title,
                style: TextStyle(
                  decoration: item.isDone ? TextDecoration.lineThrough : null,
                  color: item.isDone ? AppColors.textSecondary : AppColors.textPrimary,
                ),
              ),
              value: item.isDone,
              activeColor: AppColors.statusDone,
              onChanged: (bool? value) {
                provider.toggleChecklistItem(job.id, index);
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
            );
          })
        ],
      ),
    );
  }

  Widget _buildPhotoSection(String title, bool isBefore, List<String> photos) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...photos.map((path) => Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                GestureDetector(
                  onTap: () => _pickImage(isBefore),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.camera, color: AppColors.textSecondary),
                        SizedBox(height: 4),
                        Text('Tambah', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, CleanerJobModel job, CleanerJobsProvider provider) {
    bool allTasksDone = job.checklistItems.every((item) => item.isDone);
    bool hasBeforePhotos = job.beforePhotos.isNotEmpty;
    bool hasAfterPhotos = job.afterPhotos.isNotEmpty;
    bool canFinish = allTasksDone && hasBeforePhotos && hasAfterPhotos;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canFinish
                ? () {
                    provider.updateJobStatus(job.id, CleanerJobStatus.done);
                    // Navigate back or to success screen
                    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.cleanerHome));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pekerjaan selesai! Bagus sekali.')),
                    );
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap selesaikan semua tugas dan unggah foto sebelum/sesudah.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: canFinish ? AppColors.statusDone : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Selesaikan Pekerjaan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
