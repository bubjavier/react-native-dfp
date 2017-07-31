#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#else
#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"
#endif

@import GoogleMobileAds;

@interface RNDFPInterstitial : NSObject <RCTBridgeModule, GADInterstitialDelegate>

@property(nonatomic, strong) DFPInterstitial *interstitial;

@end
