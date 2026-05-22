import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/providers/cleaner_auth_provider.dart';
import '../../../data/providers/cleaner_jobs_provider.dart';
import '../../../navigation/app_routes.dart';

class CleanerRegisterScreen extends StatefulWidget {
  const CleanerRegisterScreen({super.key});

  @override
  State<CleanerRegisterScreen> createState() => _CleanerRegisterScreenState();
}

class _CleanerRegisterScreenState extends State<CleanerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  String _selectedArea = 'Jakarta Selatan';
  bool _agreedToTerms = false;

  final List<String> _areas = [
    'Jakarta Selatan',
    'Jakarta Pusat',
    'Jakarta Utara',
    'Jakarta Timur',
    'Jakarta Barat',
    'Tangerang',
    'Bekasi',
    'Depok',
    'Bogor',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap setujui syarat & ketentuan', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final auth = context.read<CleanerAuthProvider>();
    auth.registerCleaner(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
      area: _selectedArea,
    );
    context.read<CleanerJobsProvider>().loadDummyJobs();
    Navigator.pushReplacementNamed(context, AppRoutes.cleanerHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B8B5B), Color(0xFF00BFA5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text(
                        'Daftar Menjadi Mitra',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Bergabung & mulai berpenghasilan',
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Data Diri',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Nama Lengkap',
                      hint: 'Masukkan nama lengkap Anda',
                      controller: _nameCtrl,
                      prefixIcon: const Icon(Icons.person_outline, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Nama wajib diisi';
                        if (v.length < 3) return 'Nama terlalu pendek';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Email',
                      hint: 'email@mitra.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email wajib diisi';
                        if (!v.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Nomor HP',
                      hint: '08xxxxxxxxxx',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'No. HP wajib diisi';
                        if (v.length < 10) return 'No. HP tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    // Area Kerja Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Area Kerja', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.bgGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedArea,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
                              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                              items: _areas.map((area) => DropdownMenuItem(value: area, child: Text(area))).toList(),
                              onChanged: (val) => setState(() => _selectedArea = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Kata Sandi',
                      hint: 'Minimal 6 karakter',
                      controller: _passCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Konfirmasi Kata Sandi',
                      hint: 'Ulangi kata sandi',
                      controller: _confirmPassCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v != _passCtrl.text) return 'Kata sandi tidak cocok';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreedToTerms,
                            onChanged: (val) => setState(() => _agreedToTerms = val!),
                            activeColor: const Color(0xFF1B8B5B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Saya menyetujui syarat & ketentuan menjadi mitra cleaner ZhomeCleaner.',
                            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Consumer<CleanerAuthProvider>(
                      builder: (ctx, auth, _) => _GreenButton(
                        label: 'Daftar sebagai Mitra',
                        isLoading: auth.isLoading,
                        onTap: _register,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun? ', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text('Masuk', style: GoogleFonts.poppins(color: const Color(0xFF1B8B5B), fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreenButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  const _GreenButton({required this.label, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B8B5B), Color(0xFF00BFA5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFF1B8B5B).withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        ),
      ),
    );
  }
}
