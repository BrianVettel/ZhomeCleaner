import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/cleaner_auth_provider.dart';
import '../../../data/providers/cleaner_jobs_provider.dart';
import '../../../data/models/cleaner_job_model.dart';

class CleanerScheduleScreen extends StatefulWidget {
  const CleanerScheduleScreen({super.key});

  @override
  State<CleanerScheduleScreen> createState() => _CleanerScheduleScreenState();
}

class _CleanerScheduleScreenState extends State<CleanerScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<DateTime> _offDays = [
    DateTime.now().subtract(const Duration(days: 2)),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<CleanerAuthProvider>();
    final cleaner = authProvider.cleaner;
    final jobsProvider = context.watch<CleanerJobsProvider>();

    // ROOT: SafeArea (tidak pakai Scaffold)
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        children: [
          // ── HEADER ─────────────────────────────────────
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: const Text(
              'Jadwal & Ketersediaan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── KALENDER ─────────────────────────────
                _buildCalendar(),
                const SizedBox(height: 20),

                // ── TOGGLE KETERSEDIAAN ──────────────────
                _buildAvailabilityToggle(cleaner.isAvailable, authProvider),
                const SizedBox(height: 20),

                // ── PEKERJAAN HARI TERPILIH ──────────────
                const Text(
                  'Pekerjaan Hari Terpilih',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                _buildDayJobs(jobsProvider),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 30)),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) setState(() => _calendarFormat = format);
        },
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            if (_offDays.any((d) => isSameDay(d, day))) {
              return Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Center(child: Text('${day.day}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
              );
            }
            return null;
          },
          todayBuilder: (context, day, focusedDay) {
            if (_offDays.any((d) => isSameDay(d, day))) {
              return Container(
                margin: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Center(child: Text('${day.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              );
            }
            return null;
          },
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.3), shape: BoxShape.circle),
          markerDecoration: const BoxDecoration(color: AppColors.primaryCyan, shape: BoxShape.circle),
        ),
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      ),
    );
  }

  Widget _buildAvailabilityToggle(bool isAvailable, CleanerAuthProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isAvailable ? AppColors.statusDone : Colors.grey).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isAvailable ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
              color: isAvailable ? AppColors.statusDone : Colors.grey,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Status Ketersediaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  isAvailable ? 'Siap menerima pesanan' : 'Sedang tidak tersedia',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: isAvailable,
            activeTrackColor: AppColors.statusDone,
            onChanged: (val) {
              provider.toggleAvailability();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(val ? 'Status: Tersedia' : 'Status: Tidak Tersedia'),
                behavior: SnackBarBehavior.floating,
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayJobs(CleanerJobsProvider jobsProvider) {
    final dayJobs = jobsProvider.jobs
        .where((j) => isSameDay(j.scheduledAt, _selectedDay))
        .toList();

    if (dayJobs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.calendar_badge_minus, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 10),
            const Text('Tidak ada jadwal', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: dayJobs.map((job) => _buildJobItem(job)).toList(),
    );
  }

  Widget _buildJobItem(CleanerJobModel job) {
    final time =
        '${job.scheduledAt.hour.toString().padLeft(2, '0')}:${job.scheduledAt.minute.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: AppColors.primaryBlue, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(job.serviceType,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('$time – ${job.customerName}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(job.status.label,
                style: const TextStyle(color: AppColors.primaryBlue, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}