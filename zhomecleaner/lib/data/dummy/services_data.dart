import '../models/service_model.dart';

final List<ServiceModel> dummyServices = [
  const ServiceModel(
    id: 's1',
    name: 'Kebersihan Rumah Standar',
    description:
        'Layanan pembersihan rumah menyeluruh meliputi menyapu, mengepel, membersihkan debu, dan merapikan ruangan. Cocok untuk perawatan rutin hunian Anda.',
    category: 'Rumah',
    pricePerUnit: 150000,
    priceUnit: '/jam',
    rating: 4.8,
    reviewCount: 234,
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    durationMinutes: 120,
    features: [
      'Menyapu & mengepel seluruh ruangan',
      'Membersihkan debu permukaan',
      'Merapikan barang',
      'Membersihkan kaca & cermin',
    ],
    isPopular: true,
  ),
  const ServiceModel(
    id: 's2',
    name: 'Kebersihan Rumah Premium',
    description:
        'Layanan pembersihan premium dengan standar hotel bintang 5. Termasuk deep cleaning pada semua sudut ruangan, pembersihan peralatan dapur, dan sanitasi kamar mandi.',
    category: 'Rumah',
    pricePerUnit: 250000,
    priceUnit: '/jam',
    rating: 4.9,
    reviewCount: 187,
    imageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
    durationMinutes: 180,
    features: [
      'Deep cleaning seluruh area',
      'Sanitasi kamar mandi',
      'Pembersihan dapur menyeluruh',
      'Poles lantai & permukaan',
      'Aromaterapi gratis',
    ],
    isPopular: true,
  ),
  const ServiceModel(
    id: 's3',
    name: 'Cuci Karpet & Sofa',
    description:
        'Pembersihan karpet dan sofa dengan mesin ekstrasi uap berkualitas tinggi. Menghilangkan noda membandel, debu, dan bakteri secara efektif.',
    category: 'Karpet',
    pricePerUnit: 200000,
    priceUnit: '/item',
    rating: 4.7,
    reviewCount: 156,
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
    durationMinutes: 90,
    features: [
      'Ekstraksi uap bertekanan tinggi',
      'Penghilang noda khusus',
      'Anti-bakteri & anti-tungau',
      'Pengering cepat',
    ],
    isPopular: false,
  ),
  const ServiceModel(
    id: 's4',
    name: 'Servis & Cuci AC',
    description:
        'Perawatan AC lengkap termasuk cuci filter, pembersihan evaporator, cek freon, dan pengecekan performa unit. Pastikan AC Anda dingin optimal.',
    category: 'AC',
    pricePerUnit: 175000,
    priceUnit: '/unit',
    rating: 4.8,
    reviewCount: 312,
    imageUrl: 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=400',
    durationMinutes: 60,
    features: [
      'Cuci filter & evaporator',
      'Cek tekanan freon',
      'Bersihkan kondensor',
      'Test performa AC',
    ],
    isPopular: true,
  ),
  const ServiceModel(
    id: 's5',
    name: 'Kebersihan Kamar Mandi',
    description:
        'Pembersihan kamar mandi total mulai dari lantai, dinding keramik, kloset, wastafel, hingga shower. Desinfektan standar medis digunakan.',
    category: 'Kamar Mandi',
    pricePerUnit: 100000,
    priceUnit: '/kamar',
    rating: 4.6,
    reviewCount: 98,
    imageUrl: 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=400',
    durationMinutes: 45,
    features: [
      'Sikat keramik & nat',
      'Bersihkan kloset & wastafel',
      'Desinfektan anti-bakteri',
      'Poles cermin & shower',
    ],
    isPopular: false,
  ),
  const ServiceModel(
    id: 's6',
    name: 'Kebersihan Kantor',
    description:
        'Layanan kebersihan profesional untuk ruang kantor, termasuk area kerja, pantry, toilet, dan ruang rapat. Tersedia jadwal harian, mingguan, atau bulanan.',
    category: 'Kantor',
    pricePerUnit: 200000,
    priceUnit: '/jam',
    rating: 4.7,
    reviewCount: 75,
    imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400',
    durationMinutes: 120,
    features: [
      'Bersihkan meja & workstation',
      'Sanitasi toilet kantor',
      'Bersihkan pantry',
      'Sapu & pel seluruh area',
    ],
    isPopular: false,
  ),
  const ServiceModel(
    id: 's7',
    name: 'Pasca Konstruksi',
    description:
        'Pembersihan berat setelah renovasi atau konstruksi. Menghilangkan sisa semen, cat, debu konstruksi, dan kotoran berat lainnya.',
    category: 'Spesial',
    pricePerUnit: 350000,
    priceUnit: '/jam',
    rating: 4.9,
    reviewCount: 43,
    imageUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400',
    durationMinutes: 240,
    features: [
      'Hapus sisa semen & cat',
      'Bersihkan debu konstruksi',
      'Cuci semua permukaan',
      'Pemolesan lantai akhir',
    ],
    isPopular: false,
  ),
  const ServiceModel(
    id: 's8',
    name: 'Perawatan Taman',
    description:
        'Perawatan taman rumah termasuk menyiram tanaman, memotong rumput, memangkas tanaman hias, dan membersihkan area taman dari dedaunan.',
    category: 'Taman',
    pricePerUnit: 125000,
    priceUnit: '/jam',
    rating: 4.5,
    reviewCount: 67,
    imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
    durationMinutes: 90,
    features: [
      'Potong & rapikan rumput',
      'Pangkas tanaman hias',
      'Siram & pupuk tanaman',
      'Bersihkan dedaunan',
    ],
    isPopular: false,
  ),
];

final List<Map<String, dynamic>> serviceCategories = [
  {'icon': '🏠', 'name': 'Rumah', 'id': 'Rumah'},
  {'icon': '🛋️', 'name': 'Karpet', 'id': 'Karpet'},
  {'icon': '❄️', 'name': 'AC', 'id': 'AC'},
  {'icon': '🚿', 'name': 'Kamar Mandi', 'id': 'Kamar Mandi'},
  {'icon': '🏢', 'name': 'Kantor', 'id': 'Kantor'},
  {'icon': '🌿', 'name': 'Taman', 'id': 'Taman'},
  {'icon': '🔨', 'name': 'Spesial', 'id': 'Spesial'},
  {'icon': '✨', 'name': 'Semua', 'id': 'Semua'},
];

final List<Map<String, dynamic>> promoBanners = [
  {
    'title': 'Diskon 30% Kebersihan Rumah',
    'subtitle': 'Berlaku sampai 31 Mei 2026',
    'color1': 0xFF1A73E8,
    'color2': 0xFF00BCD4,
    'emoji': '🏠',
  },
  {
    'title': 'Paket Hemat Cuci AC',
    'subtitle': '2 unit hanya Rp 280.000',
    'color1': 0xFF9C27B0,
    'color2': 0xFF673AB7,
    'emoji': '❄️',
  },
  {
    'title': 'Gratis Ongkos Kedatangan',
    'subtitle': 'Untuk pemesanan perdana Anda',
    'color1': 0xFF4CAF50,
    'color2': 0xFF009688,
    'emoji': '🎁',
  },
];

final List<Map<String, dynamic>> serviceReviews = [
  {
    'name': 'Budi Hartono',
    'avatar': 'https://i.pravatar.cc/80?img=11',
    'rating': 5.0,
    'comment':
        'Pelayanannya sangat memuaskan! Rumah jadi bersih banget dan cleanernya ramah sekali.',
    'date': '15 Mei 2026',
  },
  {
    'name': 'Sari Dewi',
    'avatar': 'https://i.pravatar.cc/80?img=5',
    'rating': 4.5,
    'comment':
        'Cepat dan profesional. Harganya juga sangat terjangkau untuk kualitas yang didapatkan.',
    'date': '12 Mei 2026',
  },
  {
    'name': 'Ahmad Fauzi',
    'avatar': 'https://i.pravatar.cc/80?img=15',
    'rating': 5.0,
    'comment':
        'Sudah langganan 3 bulan terakhir. Tidak pernah kecewa, selalu bersih dan tepat waktu!',
    'date': '8 Mei 2026',
  },
];
