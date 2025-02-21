import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String get bannerAdUnitId {
    // Test banner ad unit ID'leri
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get interstitialAdUnitId {
    // Test interstitial ad unit ID'leri
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  static String get rewardedAdUnitId {
    // Test rewarded ad unit ID'leri
    return 'ca-app-pub-3940256099942544/5224354917';
  }

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Banner ad loaded.'),
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  static Future<InterstitialAd?> createInterstitialAd() async {
    try {
      InterstitialAd? interstitialAd;
      await InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => interstitialAd = ad,
          onAdFailedToLoad: (error) => print('Interstitial ad failed to load: $error'),
        ),
      );
      return interstitialAd;
    } catch (e) {
      print('Error loading interstitial ad: $e');
      return null;
    }
  }

  static Future<RewardedAd?> createRewardedAd() async {
    try {
      RewardedAd? rewardedAd;
      await RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => rewardedAd = ad,
          onAdFailedToLoad: (error) => print('Rewarded ad failed to load: $error'),
        ),
      );
      return rewardedAd;
    } catch (e) {
      print('Error loading rewarded ad: $e');
      return null;
    }
  }
} 