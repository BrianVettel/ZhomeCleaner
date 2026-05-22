# AGENT.md — ZhomeCleaner Flutter Mobile App

## 📋 Project Overview

**Nama Aplikasi:** ZhomeCleaner  
**Jenis:** Mobile App (Flutter/Dart)  
**Platform Target:** Android & iOS  
**Versi:** 1.0.0  
**SDK Dart:** ^3.11.1  

ZhomeCleaner adalah aplikasi penyedia layanan kebersihan dan perawatan rumah tangga profesional. Aplikasi ini menghubungkan pengguna dengan staf kebersihan terlatih, tepercaya, dan bersertifikat. Pelanggan dapat memesan layanan langsung melalui aplikasi, memilih jenis layanan, jadwal, dan membayar secara digital.

---

## 🎯 Core Features (MVP)

### Fitur Utama yang Harus Diimplementasi:

1. **Splash Screen & Onboarding** — Animasi intro + 3 slide onboarding
2. **Authentication** — Login / Register / Lupa Password
3. **Home Screen** — Dashboard utama dengan kategori layanan & promo
4. **Pemilihan Layanan** — Daftar layanan kebersihan beserta harga
5. **Detail Layanan** — Deskripsi detail, gambar, rating, dan ulasan
6. **Pemesanan (Booking)** — Pilih jadwal, alamat, jumlah jam/area
7. **Pemilihan Cleaner** — Daftar mitra cleaner dengan profil & rating
8. **Ringkasan & Pembayaran** — Cart + metode bayar (dummy)
9. **Riwayat Pesanan** — Status & histori order
10. **Profil Pengguna** — Edit profil, pengaturan, logout
11. **Notifikasi** — Informasi status pesanan

---

## 🏗️ Arsitektur Proyek

### Struktur Folder `lib/`
```
lib/
├── main.dart                  # Entry point aplikasi
├── app/
│   └── app.dart               # MaterialApp & routing konfigurasi
├── core/
│   ├── constants/
│   │   ├── app_colors.dart    # Palet warna brand ZhomeCleaner
│   │   ├── app_strings.dart   # Semua teks & string statis
│   │   └── app_dimensions.dart # Spacing, radius, font size
│   ├── theme/
│   │   └── app_theme.dart     # ThemeData konfigurasi lengkap
│   ├── utils/
│   │   ├── extensions.dart    # Dart extensions utility
│   │   └── helpers.dart       # Helper functions
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_indicator.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── service_model.dart
│   │   ├── booking_model.dart
│   │   └── cleaner_model.dart
│   ├── dummy/
│   │   ├── services_data.dart  # Data dummy layanan
│   │   └── cleaners_data.dart  # Data dummy cleaner
│   └── repositories/
│       └── booking_repository.dart
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── service_card.dart
│   │       ├── promo_banner.dart
│   │       └── category_chip.dart
│   ├── services/
│   │   ├── service_list_screen.dart
│   │   └── service_detail_screen.dart
│   ├── booking/
│   │   ├── booking_screen.dart
│   │   ├── cleaner_selection_screen.dart
│   │   └── booking_summary_screen.dart
│   ├── payment/
│   │   └── payment_screen.dart
│   ├── orders/
│   │   ├── order_list_screen.dart
│   │   └── order_detail_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── notification/
│       └── notification_screen.dart
└── navigation/
    └── bottom_nav.dart        # Main navigation bar
```

---

## 🎨 Design System

### Brand Identity ZhomeCleaner

| Token | Value | Keterangan |
|-------|-------|------------|
| `primaryBlue` | `#1A73E8` | Biru kepercayaan utama |
| `primaryCyan` | `#00BCD4` | Aksen segar/kebersihan |
| `accentGreen` | `#4CAF50` | Konfirmasi/sukses |
| `bgLight` | `#F8FAFF` | Background terang |
| `bgDark` | `#0F1923` | Background gelap (dark mode) |
| `cardColor` | `#FFFFFF` | Kartu putih bersih |
| `textPrimary` | `#1C2B4A` | Teks utama gelap |
| `textSecondary` | `#6B7A99` | Teks sekunder abu |
| `gradientStart` | `#1A73E8` | Gradient mulai |
| `gradientEnd` | `#00BCD4` | Gradient selesai |

### Typography
- **Font Utama:** `Poppins` (Google Fonts)
- **Heading:** Poppins Bold / SemiBold
- **Body:** Poppins Regular / Medium
- **Caption:** Poppins Light

### Design Principles
- Gunakan **gradient biru-cyan** sebagai identitas brand
- Card dengan **border radius 16–20px** dan shadow halus
- Animasi transisi halus antar halaman (350ms)
- Icon menggunakan Material Icons + custom SVG jika diperlukan
- Bottom Navigation dengan 4 tab: Home, Order, Notif, Profil

---

## 📦 Dependencies (pubspec.yaml)

### Production Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1          # Font Poppins
  flutter_svg: ^2.0.10+1       # SVG rendering
  cached_network_image: ^3.4.1  # Image caching
  smooth_page_indicator: ^1.2.0 # Onboarding dots
  intl: ^0.20.2                 # Format tanggal/angka
  fl_chart: ^0.70.2             # Chart (optional analytics)
  lottie: ^3.3.1                # Animasi Lottie
  shimmer: ^3.0.0               # Loading skeleton effect
  fluttertoast: ^8.2.12         # Toast notification
  provider: ^6.1.5              # State management sederhana
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

---

## 🗺️ Navigation & Routing

### Named Routes
```dart
static const String splash    = '/';
static const String onboarding = '/onboarding';
static const String login     = '/login';
static const String register  = '/register';
static const String home      = '/home';
static const String services  = '/services';
static const String serviceDetail = '/service-detail';
static const String booking   = '/booking';
static const String cleanerSelect = '/cleaner-select';
static const String bookingSummary = '/booking-summary';
static const String payment   = '/payment';
static const String orders    = '/orders';
static const String orderDetail = '/order-detail';
static const String profile   = '/profile';
static const String notifications = '/notifications';
```

### Bottom Navigation Tabs
1. **Home** (Icons.home_rounded)
2. **Pesanan** (Icons.receipt_long_rounded)
3. **Notifikasi** (Icons.notifications_rounded)
4. **Profil** (Icons.person_rounded)

---

## 📱 Screen Specifications

### 1. Splash Screen
- Background gradient biru → cyan
- Logo ZhomeCleaner di tengah dengan animasi fade-in + scale
- Otomatis navigasi ke Onboarding (jika pertama kali) atau Home

### 2. Onboarding Screen
- 3 halaman slide:
  - Slide 1: "Layanan Kebersihan Profesional" — ilustrasi cleaner bekerja
  - Slide 2: "Pesan Kapan & Dimana Saja" — ilustrasi smartphone booking
  - Slide 3: "Cleaner Terlatih & Bersertifikat" — ilustrasi tim profesional
- Indikator dots di bawah
- Tombol "Mulai Sekarang" di slide terakhir

### 3. Login Screen
- Header dengan logo dan tagline
- Email + Password field
- Tombol Login (gradient biru-cyan)
- Link ke Register & Lupa Password
- Optional: Social login (Google — dummy)

### 4. Register Screen
- Field: Nama Lengkap, Email, No. HP, Password, Konfirmasi Password
- Tombol Daftar
- Link kembali ke Login

### 5. Home Screen
- **Header:** Greeting + nama user + avatar + icon notif
- **Search Bar:** Input cari layanan
- **Banner Promo:** PageView carousel (otomatis slide)
- **Kategori Layanan:** Grid icon kategori (Rumah, Kantor, Karpet, AC, dll)
- **Layanan Populer:** ListView horizontal card layanan
- **Cleaner Terpilih:** ListView horizontal card cleaner bintang

### 6. Service List Screen
- AppBar dengan nama kategori
- Filter chip (harga, rating, durasi)
- ListView card layanan dengan gambar, nama, harga, rating

### 7. Service Detail Screen
- Hero image besar
- Nama, deskripsi, harga, durasi
- Rating & ulasan pengguna (3–5 review dummy)
- Tombol "Pesan Sekarang" floating di bawah

### 8. Booking Screen
- Step indicator: Jadwal → Alamat → Cleaner → Bayar
- Pilih tanggal (DatePicker)
- Pilih jam mulai
- Input alamat
- Pilih luas area / jumlah ruangan
- Catatan tambahan

### 9. Cleaner Selection Screen
- Daftar cleaner tersedia pada jadwal tersebut
- Card: foto, nama, rating, pengalaman, harga/jam
- Pilih cleaner yang diinginkan

### 10. Booking Summary Screen
- Ringkasan pemesanan: layanan, jadwal, alamat, cleaner, harga
- Pilih metode pembayaran (dummy: Transfer Bank, QRIS, Dompet Digital)
- Tombol "Konfirmasi & Bayar"

### 11. Order List Screen
- Tab: Aktif | Selesai | Dibatalkan
- Card order dengan status badge berwarna

### 12. Profile Screen
- Avatar + nama + email
- Menu: Edit Profil, Alamat Saya, Metode Pembayaran, Bantuan, Keluar

---

## 🧩 Data Models

### UserModel
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String address;
}
```

### ServiceModel
```dart
class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double pricePerHour;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final int durationMinutes;
}
```

### CleanerModel
```dart
class CleanerModel {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int totalJobs;
  final int experienceYears;
  final bool isAvailable;
  final List<String> specializations;
}
```

### BookingModel
```dart
class BookingModel {
  final String id;
  final String serviceId;
  final String cleanerId;
  final String userId;
  final DateTime scheduledAt;
  final String address;
  final double totalPrice;
  final String status; // pending | confirmed | ongoing | done | cancelled
  final String paymentMethod;
}
```

---

## 🛠️ Development Guidelines

### Kode
- Selalu gunakan `const` constructor di mana memungkinkan
- Pisahkan logic ke dalam widget terpisah jika >50 baris
- Gunakan `Provider` untuk state management
- Semua string ditaruh di `app_strings.dart`
- Semua warna dari `AppColors`, bukan hardcoded hex

### Naming Convention
- **File:** `snake_case.dart`
- **Kelas:** `PascalCase`
- **Variabel/Method:** `camelCase`
- **Konstanta:** `SCREAMING_SNAKE_CASE` atau `camelCase` di dalam kelas

### Git Commit Style
```
feat: tambah fitur booking screen
fix: perbaiki bug navigasi bottom bar
style: update warna tombol primary
refactor: pisahkan service card ke widget terpisah
```

---

## 🚀 Build & Run

### Menjalankan Aplikasi
```bash
# Instalasi dependency
flutter pub get

# Run di emulator/device
flutter run

# Hot reload: tekan 'r' di terminal
# Hot restart: tekan 'R' di terminal
```

### Build APK
```bash
flutter build apk --release
```

---

## 📌 Agent Instructions

Ketika membantu pengembangan aplikasi ini, AI Agent harus:

1. **Selalu merujuk AGENT.md** ini sebagai sumber kebenaran untuk desain, arsitektur, dan fitur
2. **Ikuti struktur folder** yang sudah ditetapkan di atas
3. **Gunakan design system** (warna, font, spacing) yang sudah didefinisikan
4. **Buat kode yang bersih** dan mudah dibaca, dengan komentar di bagian kompleks
5. **Implementasi satu fitur lengkap** sebelum berpindah ke fitur berikutnya
6. **Data dummy realistis** — gunakan nama Indonesia, harga dalam Rupiah (IDR)
7. **Bahasa UI: Bahasa Indonesia** untuk semua teks yang terlihat pengguna
8. **Analisis sebelum kode** — selalu jelaskan apa yang akan dibuat sebelum menulis kode
9. **Gunakan MCP tools** untuk hot reload setelah setiap perubahan kode
10. **Verifikasi dengan flutter analyze** sebelum menyatakan pekerjaan selesai
