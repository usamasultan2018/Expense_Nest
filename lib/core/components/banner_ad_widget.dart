// import 'package:expense_tracker/core/utils/add_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class BannerAdWidget extends StatefulWidget {
//   const BannerAdWidget({Key? key}) : super(key: key);

//   @override
//   _BannerAdWidgetState createState() => _BannerAdWidgetState();
// }

// class _BannerAdWidgetState extends State<BannerAdWidget> {
//   BannerAd? _bannerAd;
//   bool _isAdLoaded = false;
//   int _retryCount = 0;
//   final int _maxRetries = 3; // Limit retries to avoid infinite loops

//   @override
//   void initState() {
//     super.initState();
//     _loadBannerAd();
//   }

//   void _loadBannerAd() {
//     if (_retryCount >= _maxRetries) {
//       print("Reached max retry attempts for banner ad.");
//       return;
//     }

//     _bannerAd = BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           if (mounted) {
//             setState(() {
//               _isAdLoaded = true;
//             });
//           }
//           _retryCount = 0; // Reset retry count on success
//         },
//         onAdFailedToLoad: (ad, error) {
//           print("Failed to load banner ad: ${error.message}");
//           ad.dispose();

//           // Retry logic with exponential backoff
//           _retryCount++;
//           Future.delayed(Duration(seconds: 5 * _retryCount), _loadBannerAd);
//         },
//       ),
//       request: const AdRequest(),
//     );

//     _bannerAd?.load();
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isAdLoaded) {
//       return const SizedBox.shrink(); // Prevent UI space allocation
//     }

//     return Container(
//       alignment: Alignment.center,
//       width: _bannerAd!.size.width.toDouble(),
//       height: _bannerAd!.size.height.toDouble(),
//       child: AdWidget(ad: _bannerAd!),
//     );
//   }
// }
