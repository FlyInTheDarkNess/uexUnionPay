//
//  EUExUnionPay.m
//  EUExUnionPay
//
//  Created by CeriNo on 15/12/14.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUExUnionPay.h"
#import "JSON.h"
#import "EBrowserView.h"
#import "EBrowserController.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "EUtility.h"
@interface EUExUnionPay()<UPPayPluginDelegate>
@end


@implementation EUExUnionPay



#pragma mark - EUExBase Method

- (instancetype)initWithBrwView:(EBrowserView *)eInBrwView{
    self=[super initWithBrwView:eInBrwView];
    if(self){
        
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
    if([inArguments count] < 1){
        return;
    }
    id info = [inArguments[0] JSONValue];
    if(!info || ![info isKindOfClass:[NSDictionary class]]){
        return;
    }
    if(!info[@"orderInfo"]||!info[@"mode"]){
        return;
    }
    NSString *orderInfo = info[@"orderInfo"];
    NSString *mode = info[@"mode"];
    [UPPayPlugin startPay:orderInfo mode:mode viewController:self.meBrwView.meBrwCtrler delegate:self];
    
}


#pragma mark - UPPayPluginDelegate



-(void)UPPayPluginResult:(NSString*)result{
    if([result isEqual:@"success"]){
        [self cbStartPay:0];
        return;
    }
    if([result isEqual:@"fail"]){
        [self cbStartPay:1];
        return;
    }
    if([result isEqual:@"cancel"]){
        [self cbStartPay:-1];
        return;
    }
    [self cbStartPay:-2];
    
}

#pragma mark - uex callback

-(void)cbStartPay:(NSInteger)result{
    [EUtility uexPlugin:@"uexUnionPay"
         callbackByName:@"cbStartPay"
             withObject:@{@"payResult":@(result)}
                andType:uexPluginCallbackWithJsonString
               inTarget:self.meBrwView];
}

@end
