import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/cleaner_jobs_provider.dart';
import '../../../data/models/cleaner_job_model.dart';
import '../../../navigation/app_routes.dart';

class CleanerOrdersListScreen extends StatefulWidget {
  const CleanerOrdersListScreen({super.key});

  @override
  State<CleanerOrdersListScreen> createState() => _CleanerOrdersListScreenState();
}

class _CleanerOrdersListScreenState extends State<CleanerOrdersListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<CleanerJobsProvider>();

    // ROOT: Column (tidak pakai Scaffold). Parent CleanerBottomNav sudah punya Scaffold.
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ─────────────────────────────────────────
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Manajemen Pesanan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text('Kelola seluruh pesanan Anda',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryBlue,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primaryBlue,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Aktif'),
                    Tab(text: 'Riwayat'),
                  ],
                ),
              ],
            ),
          ),

          // ── TAB CONTENT ─────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(context, jobsProvider.activeJobs, isActive: true),
                _buildList(context, jobsProvider.completedJobs, isActive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<CleanerJobModel> jobs, {required bool isActive}) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.bgGrey, shape: BoxShape.circle),
              child: Icon(
                isActive ? CupertinoIcons.doc_plaintext : CupertinoIcons.clock,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'Belum ada pesanan aktif' : 'Belum ada riwayat pesanan',
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) => _buildJobCard(context, jobs[index], isActive),
    );
  }

  Widget _buildJobCard(BuildContext context, CleanerJobModel job, bool isActive) {
    final color = _statusColor(job.status);
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.cleanerOrderDetail, arguments: job.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(job.id,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(job.status.label,
                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(job.serviceType,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(CupertinoIcons.calendar, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Text(DateFormat('dd MMM yyyy, HH:mm').format(job.scheduledAt),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(CupertinoIcons.location_solid, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(job.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isActive ? 'Estimasi Pendapatan' : 'Total Pendapatan',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  Text(
                    currency.format(job.estimatedEarnings + job.tipAmount),
                    style: TextStyle(
                      color: isActive ? AppColors.primaryBlue : AppColors.statusDone,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(CleanerJobStatus status) {
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
