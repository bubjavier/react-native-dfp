//
//  RNDFPInterstitial.m
//  RNDfp
//
//  Created by Bub on 7/28/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RNDFPInterstitial.h"

@implementation RNDFPInterstitial

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(loadAdFromAdUnitId: (NSString *)adUnitId)
{
    NSLog(@"Loading Interstitial ad...");
    self.interstitial.delegate = self;
    self.interstitial = [[DFPInterstitial alloc] initWithAdUnitID:adUnitId];
    [self.interstitial loadRequest:[DFPRequest request]];
}

RCT_EXPORT_METHOD(showAd)
{
    NSLog(@"Checking Interstitial ad...");
    if (self.interstitial.isReady) {
        NSLog(@"Showing Interstitial ad...");
        UIViewController * _root = [UIApplication sharedApplication]
            .delegate.window.rootViewController;
        [self.interstitial presentFromRootViewController:_root];
    } else {
        NSLog(@"Interstitial Ad wasn't ready");
    }
}

@end
