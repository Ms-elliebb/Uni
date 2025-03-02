import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  
  const SplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Birden fazla animasyon için controller'lar
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _textController;
  late AnimationController _glitchController;
  late AnimationController _pulseController;
  
  // Animasyonlar
  late Animation<double> _logoAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _textAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Logo animasyonu için controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );
    
    // Arka plan animasyonu için controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    // Metin animasyonu için controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    // Glitch efekti için controller
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Nabız efekti için controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Logo için bounce animasyonu
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOutQuart,
    );
    
    // Arka plan için fade ve scale animasyonu
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    );
    
    // Metin için slide ve fade animasyonu
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );
    
    // Animasyonları sırayla başlat
    _backgroundController.forward();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      _logoController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      _textController.forward();
    });
    
    // Glitch efekti için rastgele zamanlarda animasyon
    _setupGlitchAnimation();
    
    // 6 saniye sonra diğer ekrana geçiş yap
    Timer(const Duration(milliseconds: 6000), () {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        )
      );
    });
  }
  
  void _setupGlitchAnimation() {
    // Rastgele zamanlarda glitch efekti
    _glitchController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _glitchController.reset();
        
        // Glitch efekti tamamlandığında, %40 ihtimalle uzun süre aktif kalacak
        if (math.Random().nextDouble() > 0.6) {
          // Uzun süreli glitch efekti
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              _glitchController.forward();
              
              // Uzun glitch sonrası daha uzun bekleme
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (mounted) {
                  _glitchController.reverse();
                }
              });
            }
          });
        } else {
          // Normal kısa glitch efekti
          Future.delayed(Duration(milliseconds: math.Random().nextInt(1500) + 800), () {
            if (mounted) {
              _glitchController.forward();
            }
          });
        }
      }
    });
    
    // İlk glitch'i başlat
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _glitchController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _textController.dispose();
    _glitchController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Modern arka plan
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(Colors.black, const Color(0xFF1E1E1E), _backgroundAnimation.value) ?? Colors.black,
                      Color.lerp(Colors.black, const Color(0xFF2D0A0A), _backgroundAnimation.value) ?? Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Parçacık efekti
          Opacity(
            opacity: _backgroundAnimation.value,
            child: CustomPaint(
              size: Size(size.width, size.height),
              painter: ParticlesPainter(_pulseController.value),
            ),
          ),
          
          // Işık efekti
          Positioned(
            top: -size.height * 0.2,
            left: -size.width * 0.2,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: size.width * 0.7,
                  height: size.width * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00CC00).withOpacity(0.2 + (_pulseController.value * 0.1)),
                        Colors.transparent,
                      ],
                      stops: const [0.2, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Ana içerik
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Elza logosu
                AnimatedBuilder(
                  animation: Listenable.merge([_glitchController, _pulseController]),
                  builder: (context, child) {
                    // Glitch efekti
                    final glitchOffset = _glitchController.value > 0.5 ? 
                        Offset(math.Random().nextDouble() * 5 - 2.5, math.Random().nextDouble() * 5 - 2.5) : 
                        Offset.zero;
                    
                    return Transform.translate(
                      offset: glitchOffset,
                      child: ScaleTransition(
                        scale: _logoAnimation,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Arka plan efekti - Dalgalı daire
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: const Size(170, 170),
                                    painter: WaveCirclePainter(
                                      _pulseController.value,
                                      const Color(0xFF00CC00),
                                    ),
                                  );
                                },
                              ),
                              
                              // İç daire
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFF2D0A0A).withOpacity(0.7),
                                      const Color(0xFF2D0A0A).withOpacity(0.9),
                                    ],
                                    stops: const [0.0, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00CC00).withOpacity(0.2),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Logo içeriği
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFAA0000).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Arka plan ışık efekti
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              const Color(0xFF00CC00).withOpacity(0.2 + (_pulseController.value * 0.1)),
                                              Colors.transparent,
                                            ],
                                            stops: const [0.1, 1.0],
                                          ),
                                        ),
                                      ),
                                      
                                      // E harfi yerine logo
                                      AnimatedBuilder(
                                        animation: _glitchController,
                                        builder: (context, child) {
                                          return Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF00CC00).withOpacity(0.3),
                                                  blurRadius: 10,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/images/logo.png',
                                                fit: BoxFit.cover,
                                                color: _glitchController.value > 0.7 ? Colors.white.withOpacity(0.9) : null,
                                                colorBlendMode: _glitchController.value > 0.7 ? BlendMode.srcATop : null,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Glitch efekti
                              if (_glitchController.value > 0.7)
                                Positioned.fill(
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ui.ImageFilter.blur(
                                        sigmaX: 2.0,
                                        sigmaY: 2.0,
                                      ),
                                      child: CustomPaint(
                                        painter: ModernGlitchPainter(),
                                      ),
                                    ),
                                  ),
                                ),
                              
                              // Işık efekti - Göz
                              Positioned(
                                top: 65,
                                right: 55,
                                child: Container(
                                  width: 12,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFAA0000),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFAA0000).withOpacity(0.5 + (_pulseController.value * 0.3)),
                                        blurRadius: _glitchController.value > 0.5 ? 8 : 5,
                                        spreadRadius: _glitchController.value > 0.5 ? 2 : 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Dış halka
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF00CC00).withOpacity(0.1 + (_pulseController.value * 0.1)),
                                        width: 1.0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // "Created by Elza Apps" yazısı
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_textAnimation),
                  child: FadeTransition(
                    opacity: _textAnimation,
                    child: AnimatedBuilder(
                      animation: _glitchController,
                      builder: (context, child) {
                        return Text(
                          _glitchController.value > 0.7 ? 
                              "CR34T3D BY 3LZ4 4PPS" : 
                              "CREATED BY ELZA APPS",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 3.0,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF00CC00).withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Özel yükleme indikatörü
                FadeTransition(
                  opacity: _textAnimation,
                  child: const ModernLoadingIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Parçacık efekti
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  ParticlesPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00CC00).withOpacity(0.1 + (animationValue * 0.1))
      ..style = PaintingStyle.fill;
    
    // Rastgele parçacıklar
    final random = math.Random(42); // Sabit seed ile tutarlı rastgelelik
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 0.5 + (animationValue * 0.5);
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
    
    // Bağlantı çizgileri
    final linePaint = Paint()
      ..color = const Color(0xFF00CC00).withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    // Izgara çizgileri
    for (int i = 0; i < 10; i++) {
      final y = size.height * (i / 10);
      final path = Path();
      path.moveTo(0, y);
      
      for (int j = 0; j < 10; j++) {
        final x = size.width * (j / 10);
        final offset = math.sin((j / 10) * math.pi * 2 + (animationValue * math.pi)) * 10;
        path.lineTo(x, y + offset);
      }
      
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue;
}

// Modern glitch efekti
class ModernGlitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFAA0000).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    // Rastgele glitch çizgileri
    for (int i = 0; i < 5; i++) {
      final y = math.Random().nextDouble() * size.height;
      final height = math.Random().nextDouble() * 10 + 1;
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, height),
        paint,
      );
    }
    
    // Rastgele glitch noktaları
    for (int i = 0; i < 20; i++) {
      final x = math.Random().nextDouble() * size.width;
      final y = math.Random().nextDouble() * size.height;
      final radius = math.Random().nextDouble() * 5 + 1;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint..color = const Color(0xFF00CC00).withOpacity(math.Random().nextDouble() * 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Modern yükleme indikatörü
class ModernLoadingIndicator extends StatefulWidget {
  const ModernLoadingIndicator({Key? key}) : super(key: key);

  @override
  _ModernLoadingIndicatorState createState() => _ModernLoadingIndicatorState();
}

class _ModernLoadingIndicatorState extends State<ModernLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 4,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Yükleme çubuğunun daha doğal görünmesi için easeInOut eğrisi kullanıyoruz
          final curvedProgress = Curves.easeInOut.transform(_controller.value);
          return CustomPaint(
            painter: ModernLoadingBarPainter(curvedProgress),
          );
        },
      ),
    );
  }
}

// Modern yükleme çubuğu
class ModernLoadingBarPainter extends CustomPainter {
  final double progress;
  
  ModernLoadingBarPainter(this.progress);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Arka plan
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(2),
      ),
      backgroundPaint,
    );
    
    // İlerleme çubuğu
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFAA0000),
          Colors.white.withOpacity(0.8),
          const Color(0xFF00CC00),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    
    // Glitch efekti için rastgele boşluklar
    final segments = <Rect>[];
    double currentX = 0;
    final progressWidth = size.width * progress;
    
    while (currentX < progressWidth) {
      final segmentWidth = math.Random().nextDouble() * 20 + 5;
      if (math.Random().nextDouble() > 0.2 || currentX > progressWidth - 30) {
        segments.add(Rect.fromLTWH(
          currentX,
          0,
          math.min(segmentWidth, progressWidth - currentX),
          size.height,
        ));
      }
      currentX += segmentWidth;
    }
    
    for (final segment in segments) {
      canvas.drawRect(segment, progressPaint);
    }
    
    // Parlama efekti
    if (progress > 0.1) {
      final glowPaint = Paint()
        ..color = const Color(0xFF00CC00).withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, progressWidth, size.height),
          const Radius.circular(2),
        ),
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ModernLoadingBarPainter oldDelegate) => true;
}

// Dalgalı daire efekti
class WaveCirclePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  
  WaveCirclePainter(this.animationValue, this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final path = Path();
    
    // Dalgalı daire çizimi
    const segments = 120;
    const waveCount = 6; // Dalga sayısı
    const waveAmplitude = 4.0; // Dalga genliği
    
    path.moveTo(
      center.dx + radius * math.cos(0),
      center.dy + radius * math.sin(0),
    );
    
    for (int i = 1; i <= segments; i++) {
      final angle = (i / segments) * 2 * math.pi;
      final waveOffset = waveAmplitude * math.sin(angle * waveCount + animationValue * 2 * math.pi);
      final waveRadius = radius + waveOffset;
      
      path.lineTo(
        center.dx + waveRadius * math.cos(angle),
        center.dy + waveRadius * math.sin(angle),
      );
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // İkinci dalga
    final secondWavePaint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    final secondPath = Path();
    const secondWaveAmplitude = 7.0;
    
    secondPath.moveTo(
      center.dx + (radius + 5) * math.cos(0),
      center.dy + (radius + 5) * math.sin(0),
    );
    
    for (int i = 1; i <= segments; i++) {
      final angle = (i / segments) * 2 * math.pi;
      final waveOffset = secondWaveAmplitude * math.sin(angle * waveCount + (1 - animationValue) * 2 * math.pi);
      final waveRadius = radius + 5 + waveOffset;
      
      secondPath.lineTo(
        center.dx + waveRadius * math.cos(angle),
        center.dy + waveRadius * math.sin(angle),
      );
    }
    
    secondPath.close();
    canvas.drawPath(secondPath, secondWavePaint);
  }
  
  @override
  bool shouldRepaint(covariant WaveCirclePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
} 