import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static Future<InitializationStatus> init() async {
    return await MobileAds.instance.initialize();
  }

  BannerAd createBannerAd() {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (_, __) {},
      ),
      request: const AdRequest(),
    );
  }

  void loadInterstitial(void Function(InterstitialAd) onAdLoaded) {
    InterstitialAd.load(
      adUnitId:
          "ca-app-pub-3940256099942544/1033173712", // Google test interstitial ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (err) {},
      ),
    );
  }
}
