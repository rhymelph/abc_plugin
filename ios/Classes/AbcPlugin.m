#import "AbcPlugin.h"
#import "ABCAppCaller.h"
@interface AbcPlugin()
@property(nonatomic, strong)FlutterResult fResult;
@property(nonatomic, strong)NSString* callBackId;

@end

@implementation AbcPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"abc_plugin"
                                     binaryMessenger:[registrar messenger]];
    AbcPlugin* instance = [[AbcPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"requestPay" isEqualToString:call.method]) {
        [self requestPay:call result:result];
        
    }else if([@"canPay" isEqualToString:call.method]){
        [self canPay:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
    //    result(FlutterMethodNotImplemented);
}

- (void) requestPay:(FlutterMethodCall*)call result:(FlutterResult)result{
    //    NSString * appId=[call.arguments valueForKey:@"appId"];
    NSString * callbackId=[call.arguments valueForKey:@"callbackId"];
    NSString * method=[call.arguments valueForKey:@"method"];
    NSString * tokenId=[call.arguments valueForKey:@"tokenId"];
    NSString * param=[[NSString alloc] initWithFormat:@"CallbackID=%@&TokenID=%@&Method=%@",callbackId,tokenId,method];
    [[ABCAppCaller sharedAppCaller]callBankABC:@"bankabc" param:param];
    _fResult=result;
    _callBackId=callbackId;
    
}
- (void) canPay:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL canPay=[[ABCAppCaller sharedAppCaller] isABCePayAvailable:@"bankabc://"];
    result([NSNumber numberWithBool:canPay]);
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"进入前台");
    if(_fResult){
        NSLog(@"返回数据");
        _fResult([[ABCAppCaller sharedAppCaller]decryptString:_callBackId]);
        _fResult=nil;
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    NSLog(@"activie");
    
}
@end
