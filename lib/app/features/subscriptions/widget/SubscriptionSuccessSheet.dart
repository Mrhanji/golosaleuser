import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:golosaleuser/app/routes/app_routes.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

// ─── Model ───────────────────────────────────────────────────────────────────

class SubscriptionSuccessData {
  final String subscriptionId;
  final String productId;
  final int productQty;
  final double productPrice;
  final DateTime startAt;
  final DateTime endAt;
  final int planDuration;
  final double totalBill;
  final String paymentMode;
  final String status;

  SubscriptionSuccessData({
    required this.subscriptionId,
    required this.productId,
    required this.productQty,
    required this.productPrice,
    required this.startAt,
    required this.endAt,
    required this.planDuration,
    required this.totalBill,
    required this.paymentMode,
    required this.status,
  });

  // Safe int parser
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;

    if (value is int) return value;

    if (value is double) return value.toInt();

    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
  }

  // Safe double parser
  static double _parseDouble(dynamic value,
      {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;

    if (value is double) return value;

    if (value is int) return value.toDouble();

    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
  }

  // Safe string parser
  static String _parseString(dynamic value,
      {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    return value.toString();
  }

  // Safe datetime parser
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  factory SubscriptionSuccessData.fromJson(
      Map<String, dynamic>? json) {
    json ??= {};

    return SubscriptionSuccessData(
      subscriptionId:
      _parseString(json['subscriptionId']),
      productId:
      _parseString(json['productId']),
      productQty:
      _parseInt(json['productQty']),
      productPrice:
      _parseDouble(json['productPrice']),
      startAt:
      _parseDate(json['startAt']),
      endAt:
      _parseDate(json['endAt']),
      planDuration:
      _parseInt(json['planDuration']),
      totalBill:
      _parseDouble(json['totalBill']),
      paymentMode:
      _parseString(json['paymentMode'],
          defaultValue: 'offline'),
      status:
      _parseString(json['status'],
          defaultValue: 'pending'),
    );
  }
}

// ─── Controller ──────────────────────────────────────────────────────────────

class SubscriptionSuccessController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController mainController;
  late AnimationController shimmerController;
  late AnimationController pulseController;
  late AnimationController particleController;

  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;
  late Animation<double> slideAnim;
  late Animation<double> checkAnim;
  late Animation<double> shimmerAnim;
  late Animation<double> pulseAnim;
  late Animation<double> particleAnim;

  @override
  void onInit() {
    super.onInit();

    mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();

    pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    particleController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    scaleAnim = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );

    fadeAnim = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );

    slideAnim = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
    );

    checkAnim = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutBack),
    );

    shimmerAnim = shimmerController;
    pulseAnim = pulseController;
    particleAnim = particleController;

    mainController.forward();
  }

  @override
  void onClose() {
    mainController.dispose();
    shimmerController.dispose();
    pulseController.dispose();
    particleController.dispose();
    super.onClose();
  }
}

// ─── Show Helper ─────────────────────────────────────────────────────────────

void showSubscriptionSuccess(SubscriptionSuccessData data) {
  Get.bottomSheet(
    SubscriptionSuccessSheet(data: data),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: false,
  );
}

// ─── Main Widget ─────────────────────────────────────────────────────────────

class SubscriptionSuccessSheet extends StatelessWidget {
  final SubscriptionSuccessData data;

  const SubscriptionSuccessSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionSuccessController>(
      init: SubscriptionSuccessController(),
      builder: (ctrl) {
        return AnimatedBuilder(
          animation: ctrl.mainController,
          builder: (context, _) {
            return FadeTransition(
              opacity: ctrl.fadeAnim,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.88,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A0F1E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Stack(
                  children: [
                    // Ambient background glow
                    _AmbientGlow(pulseAnim: ctrl.pulseAnim),

                    // Floating particles
                    _ParticleField(particleAnim: ctrl.particleAnim),

                    // Main content
                    SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          _DragHandle(),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  const SizedBox(height: 24),
                                  _SuccessBadge(
                                    scaleAnim: ctrl.scaleAnim,
                                    checkAnim: ctrl.checkAnim,
                                    pulseAnim: ctrl.pulseAnim,
                                    shimmerAnim: ctrl.shimmerAnim,
                                  ),
                                  const SizedBox(height: 28),
                                  _SlideIn(
                                    animation: ctrl.slideAnim,
                                    delay: 0.0,
                                    child: _HeaderText(),
                                  ),
                                  const SizedBox(height: 32),
                                  _SlideIn(
                                    animation: ctrl.slideAnim,
                                    delay: 0.1,
                                    child: _SubscriptionCard(data: data),
                                  ),
                                  const SizedBox(height: 16),
                                  _SlideIn(
                                    animation: ctrl.slideAnim,
                                    delay: 0.2,
                                    child: _TimelineRow(data: data),
                                  ),
                                  const SizedBox(height: 16),
                                  _SlideIn(
                                    animation: ctrl.slideAnim,
                                    delay: 0.3,
                                    child: _BillingCard(
                                      data: data,
                                      shimmerAnim: ctrl.shimmerAnim,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  _SlideIn(
                                    animation: ctrl.slideAnim,
                                    delay: 0.4,
                                    child: _ActionButton(),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Background Effects ───────────────────────────────────────────────────────

class _AmbientGlow extends StatelessWidget {
  final Animation<double> pulseAnim;
  const _AmbientGlow({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnim,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00E5A0)
                        .withOpacity(0.08 + pulseAnim.value * 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6C63FF)
                        .withOpacity(0.07 + pulseAnim.value * 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticleField extends StatelessWidget {
  final Animation<double> particleAnim;
  const _ParticleField({required this.particleAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: particleAnim,
      builder: (_, __) => CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.88),
        painter: _ParticlePainter(particleAnim.value),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    for (int i = 0; i < 18; i++) {
      final x = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height * 0.5;
      final speed = 0.3 + rng.nextDouble() * 0.7;
      final y = baseY - (progress * speed * 80) % size.height;
      final radius = 1.0 + rng.nextDouble() * 2.5;
      final opacity = (0.1 + rng.nextDouble() * 0.25) *
          (1 - (progress * speed % 1.0));

      final colors = [
        const Color(0xFF00E5A0),
        const Color(0xFF6C63FF),
        const Color(0xFFFFD166),
      ];
      final color = colors[i % 3].withOpacity(opacity);

      canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.progress != progress;
}

// ─── UI Components ────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  final Animation<double> scaleAnim;
  final Animation<double> checkAnim;
  final Animation<double> pulseAnim;
  final Animation<double> shimmerAnim;

  const _SuccessBadge({
    required this.scaleAnim,
    required this.checkAnim,
    required this.pulseAnim,
    required this.shimmerAnim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([scaleAnim, pulseAnim, shimmerAnim]),
      builder: (_, __) {
        return ScaleTransition(
          scale: scaleAnim,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring
              Container(
                width: 130 + pulseAnim.value * 12,
                height: 130 + pulseAnim.value * 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00E5A0)
                        .withOpacity(0.15 - pulseAnim.value * 0.1),
                    width: 2,
                  ),
                ),
              ),
              // Mid ring
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00E5A0).withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
              ),
              // Core circle with shimmer
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00E5A0), Color(0xFF00B578)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5A0).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ScaleTransition(
                  scale: checkAnim,
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Subscription Active!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your plan is confirmed & ready to go',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withOpacity(0.55),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final SubscriptionSuccessData data;
  const _SubscriptionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.07),
            Colors.white.withOpacity(0.03),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF9B59F5)],
              ),
            ),
            child: const Icon(
              Icons.subscriptions_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.planDuration}-Day Plan',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5A0).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.status.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00E5A0),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Qty: ${data.productQty}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${data.productPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'per day',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final SubscriptionSuccessData data;
  const _TimelineRow({required this.data});

  String _fmt(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          _DateChip(label: 'START', date: _fmt(data.startAt),
              color: const Color(0xFF00E5A0)),
          Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00E5A0), Color(0xFFFFD166)],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0F1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Text(
                        '${data.planDuration}d',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFD166),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _DateChip(label: 'END', date: _fmt(data.endAt),
              color: const Color(0xFFFFD166)),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String date;
  final Color color;

  const _DateChip(
      {required this.label, required this.date, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _BillingCard extends StatelessWidget {
  final SubscriptionSuccessData data;
  final Animation<double> shimmerAnim;

  const _BillingCard({required this.data, required this.shimmerAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerAnim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment(-1 + shimmerAnim.value * 2.5, -0.3),
            end: Alignment(-0.5 + shimmerAnim.value * 2.5, 0.3),
            colors: const [
              Color(0xFF1A1040),
              Color(0xFF1E1550),
              Color(0xFF1A1040),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            _BillingRow(
              label: 'Subscription ID',
              value: '#${data.subscriptionId}',
              valueColor: Colors.white.withOpacity(0.7),
            ),
            _Divider(),
            _BillingRow(
              label: 'Price × ${data.productQty} qty',
              value: '₹${data.productPrice.toStringAsFixed(0)} × ${data.productQty}',
              valueColor: Colors.white.withOpacity(0.7),
            ),
            _Divider(),
            _BillingRow(
              label: 'Payment Mode',
              value: data.paymentMode.toUpperCase(),
              valueColor: const Color(0xFF6C63FF),
            ),
            _Divider(),
            _BillingRow(
              label: 'Total Charged',
              value: '₹${data.totalBill.toStringAsFixed(0)}',
              valueColor: const Color(0xFF00E5A0),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isTotal;

  const _BillingRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              color: Colors.white.withOpacity(isTotal ? 0.85 : 0.5),
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 13,
              color: valueColor,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white.withOpacity(0.07),
      height: 1,
    );
  }
}

class _ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00E5A0), Color(0xFF00B578)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5A0).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                
                Get.offAllNamed(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Go to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Get.back();
            // Navigate to subscriptions
            // Get.toNamed('/subscriptions');
          },
          child: Text(
            'View My Subscriptions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.45),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Slide-in wrapper ─────────────────────────────────────────────────────────

class _SlideIn extends StatelessWidget {
  final Animation<double> animation;
  final double delay;
  final Widget child;

  const _SlideIn({
    required this.animation,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final t = ((animation.value - delay) / (1 - delay)).clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}