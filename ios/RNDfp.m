
#import "RNDfp.h"

@implementation RNDfp

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(showBanner)
{
	NSLog(@"Pretending to fetch and display DFP Banner ads...");
}

RCT_EXPORT_METHOD(showInterstitial)
{
	NSLog(@"Pretending to fetch and display DFP Interstitial ads...");
}

@end