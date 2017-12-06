#import "RNDFPBannerView.h"

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/UIView+React.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#else
#import "RCTBridgeModule.h"
#import "UIView+React.h"
#import "RCTLog.h"
#import "RCTConvert.h"
#endif

@implementation RNDFPBannerView {
    DFPBannerView  *_bannerView;
}

- (void)insertReactSubview:(UIView *)view atIndex:(NSInteger)atIndex
{
    RCTLogError(@"DFP Banner cannot have any subviews");
    return;
}

- (void)removeReactSubview:(UIView *)subview
{
    RCTLogError(@"DFP Banner cannot have any subviews");
    return;
}

- (GADAdSize)getAdSizeFromString:(NSString *)bannerSize
{
    if ([bannerSize isEqualToString:@"banner"]) {
        return kGADAdSizeBanner;
    } else if ([bannerSize isEqualToString:@"largeBanner"]) {
        return kGADAdSizeLargeBanner;
    } else if ([bannerSize isEqualToString:@"mediumRectangle"]) {
        return kGADAdSizeMediumRectangle;
    } else if ([bannerSize isEqualToString:@"fullBanner"]) {
        return kGADAdSizeFullBanner;
    } else if ([bannerSize isEqualToString:@"leaderboard"]) {
        return kGADAdSizeLeaderboard;
    } else if ([bannerSize isEqualToString:@"smartBannerPortrait"]) {
        return kGADAdSizeSmartBannerPortrait;
    } else if ([bannerSize isEqualToString:@"smartBannerLandscape"]) {
        return kGADAdSizeSmartBannerLandscape;
    }
    else {
        return kGADAdSizeBanner;
    }
}

-(void)loadBanner {
    if (_adUnitID && (_bannerSize || _dimensions || _adSizes)) {
        GADAdSize size;
        NSMutableArray *validAdSizes;

        if (_dimensions) {
            NSNumber *width = [RCTConvert NSNumber:_dimensions[@"width"]];
            NSNumber *height = [RCTConvert NSNumber:_dimensions[@"height"]];

            CGFloat widthVal = [width doubleValue];
            CGFloat heightVal = [height doubleValue];

            CGSize cgSize = CGSizeMake(widthVal, heightVal);

            size = GADAdSizeFromCGSize(cgSize);
        } else {
            if (_adSizes) {
                validAdSizes = [[NSMutableArray alloc] init];
                for (id anAdSize in _adSizes) {
                    GADAdSize aSize;

                    // BannerSize
                    if ([anAdSize isKindOfClass:[NSString class]]) {
                        NSString *stringAdSize = (NSString *)anAdSize;

                        aSize = [self getAdSizeFromString:stringAdSize];

                        [validAdSizes addObject:NSValueFromGADAdSize(aSize)];

                        // Set size to the first one in the list
                        if (CGSizeEqualToSize(CGSizeFromGADAdSize(size), CGSizeMake(0.0, 0.0))) {
                            size = aSize;
                        }
                    }

                    // Dimensions
                    if ([anAdSize isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dictionaryAdSize = (NSDictionary *)anAdSize;

                        NSNumber *width = [RCTConvert NSNumber:dictionaryAdSize[@"width"]];
                        NSNumber *height = [RCTConvert NSNumber:dictionaryAdSize[@"height"]];

                        CGFloat widthVal = [width doubleValue];
                        CGFloat heightVal = [height doubleValue];

                        CGSize cgSize = CGSizeMake(widthVal, heightVal);

                        aSize = GADAdSizeFromCGSize(cgSize);

                        [validAdSizes addObject:NSValueFromGADAdSize(aSize)];

                        // Set size to the first one in the list
                        if (CGSizeEqualToSize(CGSizeFromGADAdSize(size), CGSizeMake(0.0, 0.0))) {
                            size = aSize;
                        }
                    }
                }
            } else {
                size = [self getAdSizeFromString:_bannerSize];
            }
        }

        _bannerView = [[DFPBannerView alloc] initWithAdSize:size];
        [_bannerView setAppEventDelegate:self]; //added Admob event dispatch listener
        // if(!CGRectEqualToRect(self.bounds, _bannerView.bounds)) {
            if (self.onSizeChange) {
                self.onSizeChange(@{
                                    @"width": [NSNumber numberWithFloat: _bannerView.bounds.size.width],
                                    @"height": [NSNumber numberWithFloat: _bannerView.bounds.size.height]
                                    });
            }
        // }
        _bannerView.delegate = self;
        _bannerView.adSizeDelegate = self;
        _bannerView.adUnitID = _adUnitID;
        _bannerView.rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

        if (validAdSizes) {
          _bannerView.validAdSizes = validAdSizes;
        }

        GADRequest *request = [GADRequest request];
        if(_testDeviceID) {
            if([_testDeviceID isEqualToString:@"EMULATOR"]) {
                request.testDevices = @[kGADSimulatorID];
            } else {
                request.testDevices = @[_testDeviceID];
            }
        }

        [_bannerView loadRequest:request];
    }
}

- (void)adView:(DFPBannerView *)banner
didReceiveAppEvent:(NSString *)name
      withInfo:(NSString *)info {
    NSLog(@"Received app event (%@, %@)", name, info);
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
    myDictionary[name] = info;
    if (self.onAdmobDispatchAppEvent) {
        self.onAdmobDispatchAppEvent(@{ name: info });
    }
}

- (void)setAdSizes:(NSArray *)adSizes
{
    if(![adSizes isEqual:_adSizes]) {
        _adSizes = adSizes;
        if (_bannerView) {
            [_bannerView removeFromSuperview];
        }
        [self loadBanner];
    }
}

- (void)setDimensions:(NSDictionary *)dimensions
{
    if(![dimensions isEqual:_dimensions]) {
        _dimensions = dimensions;
        if (_bannerView) {
            [_bannerView removeFromSuperview];
        }
        [self loadBanner];
    }
}

- (void)setBannerSize:(NSString *)bannerSize
{
    if(![bannerSize isEqual:_bannerSize]) {
        _bannerSize = bannerSize;
        if (_bannerView) {
            [_bannerView removeFromSuperview];
        }
        [self loadBanner];
    }
}

- (void)setAdUnitID:(NSString *)adUnitID
{
    if(![adUnitID isEqual:_adUnitID]) {
        _adUnitID = adUnitID;
        if (_bannerView) {
            [_bannerView removeFromSuperview];
        }
        [self loadBanner];
    }
}
- (void)setTestDeviceID:(NSString *)testDeviceID
{
    if(![testDeviceID isEqual:_testDeviceID]) {
        _testDeviceID = testDeviceID;
        if (_bannerView) {
            [_bannerView removeFromSuperview];
        }
        [self loadBanner];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews ];

    _bannerView.frame = CGRectMake(
                                   self.bounds.origin.x,
                                   self.bounds.origin.x,
                                   _bannerView.frame.size.width,
                                   _bannerView.frame.size.height);
    [self addSubview:_bannerView];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}

/// Called before the ad view changes to the new size.
- (void)adView:(DFPBannerView *)bannerView
willChangeAdSizeTo:(GADAdSize)size {
    if (self.onWillChangeAdSizeTo) {
        // bannerView calls this method on its adSizeDelegate object before the banner updates it size,
        // allowing the application to adjust any views that may be affected by the new ad size.
        self.onWillChangeAdSizeTo(@{});
    }

}

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(DFPBannerView *)adView {
    if (self.onAdViewDidReceiveAd) {
        self.onAdViewDidReceiveAd(@{});
    }
}

/// Tells the delegate an ad request failed.
- (void)adView:(DFPBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    if (self.onDidFailToReceiveAdWithError) {
        self.onDidFailToReceiveAdWithError(@{ @"error": [error localizedDescription] });
    }
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(DFPBannerView *)adView {
    if (self.onAdViewWillPresentScreen) {
        self.onAdViewWillPresentScreen(@{});
    }
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(DFPBannerView *)adView {
    if (self.onAdViewWillDismissScreen) {
        self.onAdViewWillDismissScreen(@{});
    }
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(DFPBannerView *)adView {
    if (self.onAdViewDidDismissScreen) {
        self.onAdViewDidDismissScreen(@{});
    }
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(DFPBannerView *)adView {
    if (self.onAdViewWillLeaveApplication) {
        self.onAdViewWillLeaveApplication(@{});
    }
}

@end
