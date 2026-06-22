import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '/app/routes/app_routes.dart';
import '/utils/app_constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/onBoarding-1.png',
      'title': 'Fresh Organic Milk',
      'desc': 'Sourced directly from certified organic farms, delivered fresh and pure to your doorstep.',
    },
    {
      'image': 'assets/images/onBoarding-2.png',
      'title': 'Early Morning Delivery',
      'desc': 'Get your daily milk and breakfast essentials delivered fresh at your doorstep by 7:00 AM.',
    },
    {
      'image': 'assets/images/onBoarding-3.png',
      'title': 'Flexible Subscriptions',
      'desc': 'Easily set up, pause, or resume your milk deliveries to match your calendar or travel plans.',
    },
    {
      'image': 'assets/images/onBoarding-4.png',
      'title': 'Farm-Fresh Groceries',
      'desc': 'Explore our wide catalog of dairy products, organic fruits, vegetables, and daily essentials.',
    },
    {
      'image': 'assets/images/onBoarding-5.png',
      'title': 'Easy Wallet Payments',
      'desc': 'Top up your wallet and check out seamlessly with zero transaction fees and instant cashbacks.',
    },
  ];

  void _onDone() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Widget _buildTitle(String title, Color highlightColor) {
    final words = title.split(' ');
    final List<TextSpan> spans = [];
    final Set<String> highlightWords = {
      'Fresh',
      'Organic',
      'Morning',
      'Flexible',
      'Farm-Fresh',
      'Easy',
      'Wallet'
    };

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final cleanWord = word.replaceAll(RegExp(r'[^\w-]'), '');
      final shouldHighlight = highlightWords.contains(cleanWord);
      
      spans.add(
        TextSpan(
          text: word + (i == words.length - 1 ? '' : ' '),
          style: GoogleFonts.poppins(
            color: shouldHighlight ? highlightColor : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }

  Widget _buildActionButton(Color primaryColor) {
    bool isLastPage = _currentPage == _onboardingData.length - 1;
    double progress = (_currentPage + 1) / _onboardingData.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isLastPage
          ? InkWell(
              onTap: _onDone,
              borderRadius: BorderRadius.circular(28),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      Color.lerp(primaryColor, Colors.black, 0.12)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get Started',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    backgroundColor: primaryColor.withValues(alpha: 0.12),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          Color.lerp(primaryColor, Colors.black, 0.12)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor(AppConstants.primaryColor);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background ambient highlights
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.04),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Skip Button at the top
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                    child: _currentPage == _onboardingData.length - 1
                        ? const SizedBox(height: 48) // match skip button height placeholder
                        : TextButton(
                            onPressed: _onDone,
                            child: Text(
                              'Skip',
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ),
                ),

                // Illustration + Title + Desc PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated floating illustration container with radial backdrop glow
                            Expanded(
                              flex: 3,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 260,
                                    height: 260,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          primaryColor.withValues(alpha: 0.12),
                                          primaryColor.withValues(alpha: 0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 220,
                                    height: 220,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor.withValues(alpha: 0.06),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    _onboardingData[index]['image']!,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Highlighted Text Title
                            _buildTitle(_onboardingData[index]['title']!, primaryColor),
                            const SizedBox(height: 12),
                            
                            // Text Desc
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                _onboardingData[index]['desc']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  color: Colors.grey.shade600,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom bar: Page indicators + Action button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots
                      Row(
                        children: List.generate(
                          _onboardingData.length,
                          (index) => _buildDot(index, primaryColor),
                        ),
                      ),
                      
                      // Animated Action Button (Dynamic Progress indicator or Pill)
                      _buildActionButton(primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, Color primaryColor) {
    bool isSelected = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isSelected ? 24 : 8,
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
    );
  }
}
