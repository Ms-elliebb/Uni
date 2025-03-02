import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // initState içinde Provider kullanmak yerine didChangeDependencies içinde kullanacağız
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() {
    // Provider'ı bir kere kullan
    if (_bannerAd != null) return;
    
    try {
      final adService = Provider.of<AdService>(context, listen: false);
      _bannerAd = adService.createBannerAd()
        ..load().then((value) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        }).catchError((error) {
          debugPrint('Banner reklam yüklenirken hata: $error');
        });
    } catch (e) {
      debugPrint('Banner reklam oluşturulurken hata: $e');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null || !_isAdLoaded) {
      return Container(
        height: 50,
        child: const Center(
          child: Text('Reklam yükleniyor...'),
        ),
      );
    }

    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
} 