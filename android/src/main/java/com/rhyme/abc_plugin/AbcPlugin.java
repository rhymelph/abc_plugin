package com.rhyme.abc_plugin;

import android.app.Activity;

import com.example.caller.BankABCCaller;

import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AbcPlugin
 */
public class AbcPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    private Activity activity;
    private Result onResumeResult;

    private AbcPlugin(Registrar registrar) {
        this.activity = registrar.activity();
        registrar.view().addActivityLifecycleListener(new ActivityLifecycleListener() {
            @Override
            public void onPostResume() {
                if (onResumeResult != null) {
                    String from_bankabc_param = activity.getIntent().getStringExtra("from_bankabc_param");
                    onResumeResult.success(from_bankabc_param);
                    onResumeResult = null;
                }
            }
        });
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "abc_plugin");
        channel.setMethodCallHandler(new AbcPlugin(registrar));

    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("requestPay")) {
            requestPay(call, result);
        } else if (call.method.equals("canPay")) {
            canPay(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void requestPay(MethodCall call, Result result) {
        String appId, callbackId, method, tokenId;
        appId = call.argument("appId");
        callbackId = call.argument("callbackId");
        method = call.argument("method");
        tokenId = call.argument("tokenId");
        onResumeResult = result;
        BankABCCaller.startBankABC(activity, appId, callbackId, method, tokenId);
    }

    private void canPay(MethodCall call, Result result) {
        result.success(BankABCCaller.isBankABCAvaiable(activity));
    }
}
