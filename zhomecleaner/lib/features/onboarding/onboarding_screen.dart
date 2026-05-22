import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../navigation/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      emoji: '🏠',
      title: AppStrings.ob1Title,
      subtitle: AppStrings.ob1Subtitle,
      color1: Color(0xFF1A73E8),
      color2: Color(0xFF00BCD4),
    ),
    _OnboardingData(
      emoji: '📱',
      title: AppStrings.ob2Title,
      subtitle: AppStrings.ob2Subtitle,
      color1: Color(0xFF9C27B0),
      color2: Color(0xFF673AB7),
    ),
    _OnboardingData(
      emoji: '🏅',
      title: AppStrings.ob3Title,
      subtitle: AppStrings.ob3Subtitle,
      color1: Color(0xFF4CAF50),
      color2: Color(0xFF009688),
    ),
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (ctx, i) => _OnboardingPage(data: _pages[i]),
          ),
          // Skip button
          Positioned(
            top: 52,
            right: 20,
            child: GestureDetector(
              onTap: _finishOnboarding,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppStrings.skip,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pagePadding),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withValues(alpha: 0.35),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    label: _currentPage == _pages.length - 1
                        ? AppStrings.startNow
                        : AppStrings.next,
                    backgroundColor: Colors.white,
                    textColor: _pages[_currentPage].color1,
                    useGradient: false,
                    onTap: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color1;
  final Color color2;

  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color1,
    required this.color2,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.color1, data.color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(data.emoji, style: const TextStyle(fontSize: 72)),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }
}
