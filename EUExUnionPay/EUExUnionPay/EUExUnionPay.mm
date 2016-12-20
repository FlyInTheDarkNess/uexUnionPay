//
//  EUExUnionPay.m
//  EUExUnionPay
//
//  Created by CeriNo on 15/12/14.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUExUnionPay.h"

#import "UPPaymentControl.h"
#import <AppCanKit/ACEXTScope.h>
@interface EUExUnionPay()<AppCanApplicationEventObserver>
@property (nonatomic,readonly)NSString *appURLScheme;
@end


@implementation EUExUnionPay



#pragma mark - EUExBase Method

static void (^_globalCallbackBlock)(NSNumber *result) = nil;


+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        NSNumber *ret = nil;
        if([code isEqual:@"success"]){
            ret = @0;
        }
        if([code isEqual:@"fail"]){
            ret = @1;
        }
        if([code isEqual:@"cancel"]){
            ret = @-1;
        }
        if (!ret) {
            return;
        }
        if (_globalCallbackBlock) {
            _globalCallbackBlock(ret);
        }
    }];
    return YES;
}



- (instancetype)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine{
    self = [super initWithWebViewEngine:engine];
    if (self) {
    }
    return self;
}


- (void)clean{
    
}

- (void)dealloc{
    [self clean];
}


- (NSString *)appURLScheme{
    static NSString *scheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *schemeInfo = [[NSBundle mainBundle].infoDictionary[@"CFBundleURLTypes"] firstObject];
        scheme = [schemeInfo[@"CFBundleURLSchemes"] firstObject];
    });
    return scheme;
}

#pragma mark - API

-(void)startPay:(NSMutableArray *)inArguments{
    
    ACArgsUnpack(NSDictionary *info,ACJSFunctionRef *cb) = inArguments;
    NSString *orderInfo = stringArg(info[@"orderInfo"]);
    NSString *mode = stringArg(info[@"mode"]);
    UEX_PARAM_GUARD_NOT_NIL(orderInfo);
    UEX_PARAM_GUARD_NOT_NIL(mode)
    
    @weakify(self);
    _globalCallbackBlock = ^(NSNumber *ret){
        @strongify(self);
        NSDictionary *resultDict = @{@"payResult":ret};
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexUnionPay.cbStartPay" arguments:ACArgsPack(resultDict.ac_JSONFragment)];
        [cb executeWithArguments:ACArgsPack(ret)];
    };
    
    [[UPPaymentControl defaultControl] startPay:orderInfo fromScheme:self.appURLScheme mode:mode viewController:[self.webViewEngine viewController]];
    
}




@end
