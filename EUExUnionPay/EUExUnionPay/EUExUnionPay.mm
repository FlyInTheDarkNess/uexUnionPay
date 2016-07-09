//
//  EUExUnionPay.m
//  EUExUnionPay
//
//  Created by CeriNo on 15/12/14.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUExUnionPay.h"

#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import <AppCanKit/ACEXTScope.h>
@interface EUExUnionPay()<UPPayPluginDelegate>
@property (nonatomic,strong)ACJSFunctionRef *cb;
@end


@implementation EUExUnionPay



#pragma mark - EUExBase Method

- (instancetype)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine
{
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

#pragma mark - API

-(void)startPay:(NSMutableArray *)inArguments{
    
    ACArgsUnpack(NSDictionary *info,ACJSFunctionRef *cb) = inArguments;
    NSString *orderInfo = stringArg(info[@"orderInfo"]);
    NSString *mode = stringArg(info[@"mode"]);
    if (!orderInfo || !mode) {
        return;
    }
    self.cb = cb;
    
    [UPPayPlugin startPay:orderInfo mode:mode viewController:[self.webViewEngine viewController] delegate:self];
    
}


#pragma mark - UPPayPluginDelegate



-(void)UPPayPluginResult:(NSString*)result{
    
    __block NSInteger ret = -2;
    @onExit{
        NSDictionary *resultDict = @{@"payResult":@(ret)};
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexUnionPay.cbStartPay" arguments:ACArgsPack(resultDict.ac_JSONFragment)];
        [self.cb executeWithArguments:ACArgsPack(resultDict)];
        self.cb = nil;
    };
    
    
    
    if([result isEqual:@"success"]){
        ret = 0;
    }
    if([result isEqual:@"fail"]){
        ret = 1;
    }
    if([result isEqual:@"cancel"]){
        ret = -1;
    }
}

#pragma mark - uex callback


@end
