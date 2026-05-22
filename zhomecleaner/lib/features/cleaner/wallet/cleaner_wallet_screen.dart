import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/cleaner_auth_provider.dart';

class CleanerWalletScreen extends StatelessWidget {
  const CleanerWalletScreen({super.key});

  static const _history = [
    {'title': 'Pencairan Dana', 'date': '19 Mei 2026', 'amount': -500000, 'type': 'out'},
    {'title': 'Pendapatan #JOB-001', 'date': '18 Mei 2026', 'amount': 185000, 'type': 'in'},
    {'title': 'Pendapatan #JOB-002', 'date': '18 Mei 2026', 'amount': 120000, 'type': 'in'},
    {'title': 'Tip Pelanggan', 'date': '17 Mei 2026', 'amount': 25000, 'type': 'in'},
    {'title': 'Pencairan Dana', 'date': '15 Mei 2026', 'amount': -300000, 'type': 'out'},
    {'title': 'Pendapatan #JOB-003', 'date': '14 Mei 2026', 'amount': 150000, 'type': 'in'},
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<CleanerAuthProvider>();
    final cleaner = authProvider.cleaner;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // ROOT: SafeArea (tidak pakai Scaffold)
    return SafeArea(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // ── HEADER ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: const Text(
                'Dompet Saya',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
          ),

          // ── BALANCE CARD ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBalanceCard(context, cleaner.walletBalance, currency),
            ),
          ),

          // ── BANK INFO ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildBankInfo(cleaner.bankAccountNumber),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── SECTION: RIWAYAT ────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Riwayat Transaksi',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── LIST TRANSAKSI ──────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tx = _history[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTxItem(tx, currency),
                );
              },
              childCount: _history.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance, NumberFormat currency) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Total Saldo', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            currency.format(balance),
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showWithdrawDialog(context, balance),
              icon: const Icon(CupertinoIcons.arrow_up_right_square, size: 18),
              label: const Text('Tarik Saldo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankInfo(String? bankAccount) {
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(CupertinoIcons.building_2_fill, color: AppColors.primaryBlue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Rekening Pencairan',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  bankAccount?.isNotEmpty == true ? bankAccount! : 'Belum diatur',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const Icon(CupertinoIcons.pencil, color: AppColors.primaryBlue, size: 18),
        ],
      ),
    );
  }

  Widget _buildTxItem(Map<String, Object> tx, NumberFormat currency) {
    final isOut = tx['type'] == 'out';
    final amount = (tx['amount'] as int).abs();
    final formattedAmount = NumberFormat.currency(
      locale: 'id_ID',
      symbol: isOut ? '- Rp ' : '+ Rp ',
      decimalDigits: 0,
    ).format(amount);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isOut ? Colors.orange : AppColors.statusDone).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isOut ? CupertinoIcons.arrow_up_right : CupertinoIcons.arrow_down_left,
              color: isOut ? Colors.orange : AppColors.statusDone,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tx['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 3),
                Text(tx['date'] as String,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(
            formattedAmount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isOut ? AppColors.textPrimary : AppColors.statusDone,
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, double balance) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tarik Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Masukkan jumlah yang ingin ditarik:',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permintaan penarikan sedang diproses'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Tarik', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
