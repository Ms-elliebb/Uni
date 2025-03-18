import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  
  factory AdService() => _instance;
  
  AdService._internal();
  
  bool _isInitialized = false;
  
  // Reklamların görünürlüğünü kontrol eden bayrak
  bool showAds = true;
  
  // Test reklamları için ID'ler
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  // Gerçek reklamlar için ID'ler (Gerçek ID'lerinizi buraya ekleyin)
  static const String _bannerAdUnitId = kDebugMode ? _testBannerAdUnitId : 'GERÇEK_BANNER_ID';
  static const String _interstitialAdUnitId = kDebugMode ? _testInterstitialAdUnitId : 'GERÇEK_INTERSTITIAL_ID';
  
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  
  // AdMob'u başlat
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdMob başarıyla başlatıldı');
    } catch (e) {
      debugPrint('AdMob başlatılırken hata: $e');
    }
  }
  
  // Banner reklam oluştur
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner reklam yüklendi.');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner reklam yüklenemedi: ${error.message}');
          ad.dispose();
        },
      ),
    );
  }
  
  // Interstitial reklam yükle
  void loadInterstitialAd() {
    if (!_isInitialized) {
      debugPrint('AdMob henüz başlatılmadı. Interstitial reklam yüklenemedi.');
      return;
    }
    
    try {
      InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            
            // Reklam kapatıldığında
            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                _isInterstitialAdReady = false;
                ad.dispose();
                loadInterstitialAd(); // Yeni reklam yükle
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('Interstitial reklam gösterilirken hata: ${error.message}');
                _isInterstitialAdReady = false;
                ad.dispose();
                loadInterstitialAd(); // Yeni reklam yükle
              },
            );
            
            debugPrint('Interstitial reklam yüklendi.');
          },
          onAdFailedToLoad: (error) {
            _isInterstitialAdReady = false;
            debugPrint('Interstitial reklam yüklenemedi: ${error.message}');
          },
        ),
      );
    } catch (e) {
      debugPrint('Interstitial reklam yüklenirken hata: $e');
    }
  }
  
  // Interstitial reklamı göster
  void showInterstitialAd() {
    if (!_isInitialized) {
      debugPrint('AdMob henüz başlatılmadı. Interstitial reklam gösterilemedi.');
      return;
    }
    
    // Reklamlar gizlenmişse gösterme
    if (!showAds) {
      debugPrint('Reklamlar gizli olduğu için interstitial reklam gösterilmedi.');
      return;
    }
    
    if (_isInterstitialAdReady && _interstitialAd != null) {
      try {
        _interstitialAd!.show();
      } catch (e) {
        debugPrint('Interstitial reklam gösterilirken hata: $e');
      }
    } else {
      debugPrint('Interstitial reklam hazır değil.');
      loadInterstitialAd();
    }
  }
  
  // Kaynakları temizle
  void dispose() {
    _interstitialAd?.dispose();
  }
  
  // Reklamların görünürlüğünü değiştir
  void setAdsVisibility(bool visible) {
    showAds = visible;
    debugPrint('Reklamların görünürlüğü: ${visible ? 'Açık' : 'Kapalı'}');
  }
} 