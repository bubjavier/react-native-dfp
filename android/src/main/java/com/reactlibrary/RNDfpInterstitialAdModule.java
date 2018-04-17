package com.reactlibrary;

import android.os.Handler;
import android.os.Looper;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.doubleclick.PublisherAdRequest;
import com.google.android.gms.ads.doubleclick.PublisherInterstitialAd;

import java.util.HashMap;
import java.util.Map;

public class RNDfpInterstitialAdModule extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "RNDFPInterstitial";

    PublisherInterstitialAd mPublisherInterstitialAd;


    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public RNDfpInterstitialAdModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mPublisherInterstitialAd = new PublisherInterstitialAd(reactContext);

    }


    @ReactMethod
    public void loadAdFromAdUnitId(final String adUnitID) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run () {
                if (mPublisherInterstitialAd.getAdUnitId() == null) {
                    mPublisherInterstitialAd.setAdUnitId(adUnitID);
                    mPublisherInterstitialAd.loadAd(new PublisherAdRequest.Builder().build());
                }
            }
        });


    }

    @ReactMethod
    public void showAd() {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run () {
                if (mPublisherInterstitialAd.isLoaded()) {
                    mPublisherInterstitialAd.show();
                } else {

                }
            }
        });
    }

    @javax.annotation.Nullable
    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("simulatorId", AdRequest.DEVICE_ID_EMULATOR);
        return constants;
    }
}