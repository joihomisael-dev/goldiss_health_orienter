import 'package:flutter/material.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  const AnalysisLoadingScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisLoadingScreen> createState() => _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState extends State<AnalysisLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Animation de pulse pour les cercles
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Animation de rotation pour l'icône
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animation des cercles concentriques
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Cercle extérieur avec pulse
                          Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Opacity(
                              opacity: _opacityAnimation.value * 0.6,
                              child: Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      191,
                                      195,
                                      202,
                                    ),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Cercle moyen avec pulse
                          Transform.scale(
                            scale: _pulseAnimation.value * 0.98,
                            child: Opacity(
                              opacity: _opacityAnimation.value * 0.8,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFD1F0ED),
                                ),
                              ),
                            ),
                          ),
                          // Cercle intérieur blanc
                          Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A14A896),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: AnimatedBuilder(
                              animation: _rotationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale:
                                      1.0 + (_pulseAnimation.value - 1.0) * 0.5,
                                  child: Icon(
                                    Icons.favorite,
                                    color: const Color(0xFF14A896),
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // Texte avec animation de points
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          children: [
                            const TextSpan(
                              text: 'Anal',
                              style: TextStyle(color: Color(0xFF1A2332)),
                            ),
                            const TextSpan(
                              text: 'yse en cours',
                              style: TextStyle(color: Color(0xFF1A2332)),
                            ),
                            TextSpan(
                              text: _getLoadingDots(),
                              style: const TextStyle(color: Color(0xFF1A2332)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Nous vérifions d\'abord les signes nécessitant une consultation ',
                          ),
                          TextSpan(
                            text: 'urgente',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Section "Données sécurisées" avec animation de fade
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value * 0.7 + 0.3,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade400,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'DONNÉES SÉCURISÉES',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour animer les points "..."
  String _getLoadingDots() {
    final progress = _pulseController.value;
    if (progress < 0.33) {
      return '.';
    } else if (progress < 0.66) {
      return '..';
    } else {
      return '...';
    }
  }
}
