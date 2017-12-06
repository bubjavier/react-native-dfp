import React from 'react';
import {
  requireNativeComponent,
  View,
} from 'react-native';
import PropTypes from 'proptypes';

const RNBanner = requireNativeComponent('RNDFPBanner', DFPBanner);

export default class DFPBanner extends React.Component {

  constructor() {
    super();
    this.onSizeChange = this.onSizeChange.bind(this);
    this.state = {
      style: {},
    };
  }

  onSizeChange(event) {
    const { height, width } = event.nativeEvent;
    this.setState({ style: { width, height } });
  }

  render() {
    const { adUnitID, testDeviceID, dimensions, style, didFailToReceiveAdWithError, admobDispatchAppEvent } = this.props;
    let { bannerSize, adSizes } = this.props;

    // Dimensions gets highest priority
    if (dimensions && dimensions.width && dimensions.height) {
      bannerSize = undefined;
      adSizes = undefined;
    }

    // AdSizes gets second priority
    if (adSizes && adSizes.length > 0) {
      bannerSize = undefined;
    }

    // Default to something if nothing is set
    if (!bannerSize && (!dimensions || !dimensions.width || !dimensions.height) && (!adSizes || !adSizes.length > 0)) {
       bannerSize = 'smartBannerPortrait';
    }

    return (
      <View style={this.props.style}>
        <RNBanner
          style={this.state.style}
          onSizeChange={this.onSizeChange.bind(this)}
          onAdViewDidReceiveAd={this.props.adViewDidReceiveAd}
          onDidFailToReceiveAdWithError={(event) => didFailToReceiveAdWithError(event.nativeEvent.error)}
          onAdViewWillPresentScreen={this.props.adViewWillPresentScreen}
          onAdViewWillDismissScreen={this.props.adViewWillDismissScreen}
          onAdViewDidDismissScreen={this.props.adViewDidDismissScreen}
          onAdViewWillLeaveApplication={this.props.adViewWillLeaveApplication}
          onAdmobDispatchAppEvent={(event) => admobDispatchAppEvent(event)}
          adSizes={adSizes}
          dimensions={dimensions}
          testDeviceID={testDeviceID}
          adUnitID={adUnitID}
          bannerSize={bannerSize} />
      </View>
    );
  }
}

DFPBanner.propTypes = {
  // style: View.propTypes.style,

  /**
   * AdMob iOS library banner size constants
   * (https://developers.google.com/admob/ios/banner)
   * banner (320x50, Standard Banner for Phones and Tablets)
   * largeBanner (320x100, Large Banner for Phones and Tablets)
   * mediumRectangle (300x250, IAB Medium Rectangle for Phones and Tablets)
   * fullBanner (468x60, IAB Full-Size Banner for Tablets)
   * leaderboard (728x90, IAB Leaderboard for Tablets)
   * smartBannerPortrait (Screen width x 32|50|90, Smart Banner for Phones and Tablets)
   * smartBannerLandscape (Screen width x 32|50|90, Smart Banner for Phones and Tablets)
   *
   * banner is default
   */
  bannerSize: PropTypes.string,

  /**
   * Custom banner size (instead of using bannerSize)
   */
  dimensions: PropTypes.shape({
    height: PropTypes.number,
    width: PropTypes.number,
  }),

  /**
   * Array of some combination of bannerSize and dimensions that are valid for the ad
   * Example: ['mediumRectangle', { width: 320, height: 400 }, 'smartBannerPortrait']
   */
  adSizes: PropTypes.array,

  /**
   * AdMob ad unit ID
   */
  adUnitID: PropTypes.string,

  /**
   * Test device ID
   */
  testDeviceID: PropTypes.string,

  /**
   * AdMob iOS library events
   */
  adViewDidReceiveAd: PropTypes.func,
  didFailToReceiveAdWithError: PropTypes.func,
  adViewWillPresentScreen: PropTypes.func,
  adViewWillDismissScreen: PropTypes.func,
  adViewDidDismissScreen: PropTypes.func,
  adViewWillLeaveApplication: PropTypes.func,
  admobDispatchAppEvent: PropTypes.func,
  // ...View.propTypes,
};

DFPBanner.defaultProps = {
    didFailToReceiveAdWithError: () => {},
    admobDispatchAppEvent: () => {}
};
