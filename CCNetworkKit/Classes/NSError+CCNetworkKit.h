//
//  NSError+Help.h
//  KDLogistics
//
//  Created by cc on 2018/1/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (CCNetworkKit)

- (NSString *)errorMessage;

//- (NSString *)errorFormatData;

+ (NSError *)responseResultError:(id)response;

//+ (NSError *)noNetworkError;
//
+ (NSError *)responseDataFormatError:(id)response;
//
//+ (NSError *)loginInterceptErrorWithMsg:(NSString *)msg response:(id)response;
//
//+ (NSError *)changeRoleFailError:(id)response;
//
//+ (NSError *)autoLoginFailError;

@end
