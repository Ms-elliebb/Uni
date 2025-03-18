import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  
  const SplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Animasyon denetleyicileri
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  // Animasyonlar
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Ana animasyon denetleyicisi
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    
    // Nefes alma efekti için denetleyici
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    
    // Rotasyon animasyonu
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 30000),
    )..repeat();
    
    // Logo animasyonu - ölçeklendirme
    _logoScaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    
    // Logo animasyonu - opaklık
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5),
      ),
    );
    
    // Metin animasyonu
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    
    // Ana animasyonu başlat
    _mainController.forward();
    
    // Splash ekranında kalma süresi
    Timer(const Duration(milliseconds: 5500), () {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeInOut;
            var opacity = Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: curve)
            );
            
            return FadeTransition(
              opacity: opacity,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        )
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Arka plan gradyanı
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF101010),
                  const Color(0xFF000000),
                ],
              ),
            ),
          ),
          
          // Modern ızgara çizgileri
          CustomPaint(
            size: Size(size.width, size.height),
            painter: ModernLinesPainter(
              animationValue: _rotationController.value,
            ),
          ),
          
          // Ana içerik
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ve çevresi
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _logoScaleAnimation, 
                    _logoOpacityAnimation, 
                    _pulseController,
                  ]),
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Dış halka
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color.lerp(
                                      const Color(0xFFD32F2F),
                                      const Color(0xFF4CAF50),
                                      _pulseController.value,
                                    )!.withOpacity(0.7),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              
                              // İç logo bölümü
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                  border: Border.all(
                                    color: const Color(0xFFD32F2F),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD32F2F).withOpacity(0.2),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Dönen yay efekti
                              AnimatedBuilder(
                                animation: _rotationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotationController.value * 2 * math.pi,
                                    child: CustomPaint(
                                      size: const Size(180, 180),
                                      painter: CircleArcPainter(
                                        progress: _pulseController.value,
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
                FadeTransition(
                  opacity: _textAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: const Color(0xFFD32F2F).withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      "CREATED BY ELZA APPS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Yükleme göstergesi
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

// Modern Lines Painter - Arka plan ızgara çizgileri
class ModernLinesPainter extends CustomPainter {
  final double animationValue;
  
  ModernLinesPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Arka plan ızgara
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3
      ..color = Colors.white.withOpacity(0.05);
    
    // Yatay çizgiler
    final horizontalSpacing = size.height / 12;
    for (int i = 0; i < 12; i++) {
      final y = i * horizontalSpacing;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
    
    // Dikey çizgiler
    final verticalSpacing = size.width / 16;
    for (int i = 0; i < 16; i++) {
      final x = i * verticalSpacing;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
    
    // Renkli aksan çizgileri
    final redPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFFD32F2F).withOpacity(0.3);
    
    final greenPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF4CAF50).withOpacity(0.3);
    
    // Dönen çapraz çizgiler
    final rotationAngle = animationValue * math.pi / 6;
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    canvas.translate(-center.dx, -center.dy);
    
    // Kırmızı ve yeşil çapraz çizgiler
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.7),
      redPaint,
    );
    
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.3),
      greenPaint,
    );
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ModernLinesPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Yükleme göstergesi widget'ı
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
      duration: const Duration(milliseconds: 2000),
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
      width: 150,
      height: 4,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ModernLoadingPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

// Yükleme göstergesi çizici
class ModernLoadingPainter extends CustomPainter {
  final double progress;
  
  ModernLoadingPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    // Arka plan
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
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
          const Color(0xFFD32F2F),
          const Color(0xFF4CAF50),
          const Color(0xFFD32F2F),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width * 2, size.height))
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * progress, size.height),
        const Radius.circular(2),
      ),
      progressPaint,
    );
    
    // Parlama efekti
    if (progress > 0.1) {
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * progress - 10, 0, 10, size.height),
          const Radius.circular(2),
        ),
        glowPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ModernLoadingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Dönen yay çizici
class CircleArcPainter extends CustomPainter {
  final double progress;
  
  CircleArcPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Yay çizgisi
    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Color.lerp(
          const Color(0xFFD32F2F),
          const Color(0xFF4CAF50),
          progress,
        )!.withOpacity(0.7);
    
    // Yay çizimi
    final path = Path();
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    
    path.addArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
    );
    
    canvas.drawPath(path, pathPaint);
    
    // Yay üzerindeki hareketli nokta
    final pointAngle = startAngle + sweepAngle;
    final pointPosition = Offset(
      center.dx + radius * math.cos(pointAngle),
      center.dy + radius * math.sin(pointAngle),
    );
    
    final pointPaint = Paint()
      ..color = progress < 0.5 ? 
        const Color(0xFFD32F2F) : 
        const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pointPosition, 3, pointPaint);
  }

  @override
  bool shouldRepaint(covariant CircleArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
} 