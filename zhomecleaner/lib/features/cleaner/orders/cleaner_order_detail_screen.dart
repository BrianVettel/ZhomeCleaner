import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/cleaner_jobs_provider.dart';
import '../../../data/models/cleaner_job_model.dart';
import '../../../navigation/app_routes.dart';

class CleanerOrderDetailScreen extends StatelessWidget {
  final String jobId;

  const CleanerOrderDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<CleanerJobsProvider>();
    final job = jobsProvider.getJobById(jobId);

    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pesanan')),
        body: const Center(child: Text('Pesanan tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text('Pesanan ${job.id}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(job),
            const SizedBox(height: 16),
            _buildCustomerInfo(job),
            const SizedBox(height: 16),
            _buildJobDetails(job),
            const SizedBox(height: 16),
            _buildEarnings(job),
            const SizedBox(height: 100), // spacing for bottom bar
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(context, job, jobsProvider),
    );
  }

  Widget _buildStatusCard(CleanerJobModel job) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Status Pesanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(job.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              job.status.label,
              style: TextStyle(
                color: _getStatusColor(job.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(CleanerJobModel job) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pelanggan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                child: const Icon(CupertinoIcons.person_fill, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.customerName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      job.customerPhone,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.phone_circle_fill, color: AppColors.statusDone, size: 36),
                onPressed: () {
                  // Call customer
                },
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(CupertinoIcons.location_solid, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alamat Pelanggan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.address,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetails(CleanerJobModel job) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Layanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _detailRow('Jenis Layanan', job.serviceType),
          const SizedBox(height: 12),
          _detailRow('Jadwal', DateFormat('dd MMMM yyyy, HH:mm').format(job.scheduledAt)),
          const SizedBox(height: 12),
          _detailRow('Durasi', '${job.durationMinutes} Menit'),
          const SizedBox(height: 12),
          _detailRow('Detail Ruangan', job.roomDetails),
          if (job.specialNotes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Catatan Khusus:', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(CupertinoIcons.exclamationmark_triangle_fill, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          job.specialNotes,
                          style: const TextStyle(color: Colors.orange, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildEarnings(CleanerJobModel job) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pendapatan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimasi Tarif', style: TextStyle(color: AppColors.textSecondary)),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(job.estimatedEarnings),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (job.tipAmount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tip Pelanggan', style: TextStyle(color: AppColors.statusDone)),
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(job.tipAmount),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.statusDone),
                ),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pendapatan', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(job.estimatedEarnings + job.tipAmount),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, CleanerJobModel job, CleanerJobsProvider provider) {
    if (job.status == CleanerJobStatus.done || job.status == CleanerJobStatus.cancelled) {
      return const SizedBox.shrink();
    }

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
            onPressed: () {
              if (job.status == CleanerJobStatus.incoming) {
                provider.acceptJob(job.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesanan berhasil diterima!')),
                );
              } else if (job.status == CleanerJobStatus.accepted) {
                provider.updateJobStatus(job.id, CleanerJobStatus.heading);
              } else if (job.status == CleanerJobStatus.heading) {
                // Update to working and go to job execution screen
                provider.updateJobStatus(job.id, CleanerJobStatus.working);
                // Navigate to execution screen
                Navigator.pushNamed(context, AppRoutes.cleanerJobExecution, arguments: job.id);
              } else if (job.status == CleanerJobStatus.working) {
                Navigator.pushNamed(context, AppRoutes.cleanerJobExecution, arguments: job.id);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              job.status.nextActionLabel,
              style: const TextStyle(
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

  Color _getStatusColor(CleanerJobStatus status) {
    switch (status) {
      case CleanerJobStatus.incoming:
        return Colors.orange;
      case CleanerJobStatus.accepted:
        return AppColors.primaryBlue;
      case CleanerJobStatus.heading:
        return Colors.blue;
      case CleanerJobStatus.working:
        return Colors.deepPurple;
      case CleanerJobStatus.done:
        return AppColors.statusDone;
      case CleanerJobStatus.cancelled:
        return AppColors.error;
    }
  }
}
