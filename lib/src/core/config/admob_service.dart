// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdMobService {
//   static String? get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-4075751266346417/2059135820';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-4075751266346417/3284587585';
//     }
//     return null;
//   }

//   static final BannerAdListener bannerAdListener = BannerAdListener(
//     onAdLoaded: (ad) => debugPrint('==========Ad Loaded======='),
//     onAdFailedToLoad: (ad, error) {
//       ad.dispose();
//       debugPrint('==========Ad Failed to Loaded=======');
//     },
//     onAdOpened: (ad) => debugPrint('==========AD Opened======='),
//     onAdClosed: (ad) => debugPrint('==========AD Closed======='),
//   );
// }
