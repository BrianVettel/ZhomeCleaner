import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/providers/booking_provider.dart';
import '../../navigation/app_routes.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryBlue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryBlue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _next() {
    final bp = context.read<BookingProvider>();
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal terlebih dahulu')),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih waktu terlebih dahulu')),
      );
      return;
    }
    bp.setDate(_selectedDate!);
    bp.setTime(_selectedTime!);
    bp.setAddress(_addressCtrl.text);
    bp.setNotes(_notesCtrl.text);
    Navigator.pushNamed(context, AppRoutes.cleanerSelect);
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<BookingProvider>().selectedService;
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Buat Pesanan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator
            _StepIndicator(currentStep: 0),
            const SizedBox(height: 24),

            // Service info card
            if (service != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColors.bgGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Text('🧹', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text('Layanan yang dipilih', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Date picker
            Text('Pilih Tanggal & Waktu', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: _InfoBox(
                      icon: Icons.calendar_today_rounded,
                      label: AppStrings.selectDate,
                      value: _selectedDate == null
                          ? 'Pilih tanggal'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickTime,
                    child: _InfoBox(
                      icon: Icons.access_time_rounded,
                      label: AppStrings.selectTime,
                      value: _selectedTime == null
                          ? 'Pilih waktu'
                          : _selectedTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Address
            Text(AppStrings.address, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            CustomTextField(
              label: '',
              hint: AppStrings.addressHint,
              controller: _addressCtrl,
              maxLines: 3,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: Icon(Icons.location_on_rounded, size: 20, color: AppColors.primaryBlue),
              ),
            ),
            const SizedBox(height: 20),

            // Notes
            CustomTextField(
              label: AppStrings.notes,
              hint: AppStrings.notesHint,
              controller: _notesCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            CustomButton(
              label: '${AppStrings.next} — ${AppStrings.selectCleaner}',
              onTap: _next,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Jadwal', 'Cleaner', 'Bayar'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: (i ~/ 2) < currentStep ? AppColors.primaryBlue : AppColors.divider,
            ),
          );
        }
        final step = i ~/ 2;
        final done = step < currentStep;
        final active = step == currentStep;
        return Column(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: (done || active) ? AppColors.primaryGradient : null,
                color: (done || active) ? null : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                    : Text('${step + 1}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: active ? Colors.white : AppColors.textHint)),
              ),
            ),
            const SizedBox(height: 4),
            Text(steps[step], style: GoogleFonts.poppins(fontSize: 10, fontWeight: active ? FontWeight.w600 : FontWeight.normal, color: active ? AppColors.primaryBlue : AppColors.textSecondary)),
          ],
        );
      }),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
                Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
