//
//  NSError+Help.m
//  KDLogistics
//
//  Created by cc on 2018/1/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "NSError+CCNetworkKit.h"
#import "CCResponseModel.h"

@implementation NSError (CCNetworkKit)

- (NSString *)errorMessage {
    if ([self isKindOfClass:[NSError class]]) {
//        if (self.code==APIErrorCode_LoginCrowded) {
//            NSLog(@"账号被挤");
//            return nil;
//        }
//        if (self.code==APIErrorCode_AutoLoginFail) {
//            NSLog(@"自动登录失败");
//            return nil;
//        }
        NSDictionary *infoDic = ((NSError *)self).userInfo;
        NSString *msg = infoDic[NSLocalizedDescriptionKey];
//        if (!msg) {
//            NSDictionary *dic = infoDic[NSLocalizedFailureReasonErrorKey];
//            NSData *jsonData = [jsonError dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                options:NSJSONReadingMutableContainers
//                                                                  error:&err];
//            msg = dic[@"msg"];
//        }
        if (msg.length) {
            return msg;
        }
//        else if (self.code==APIErrorCode_DataFormatError) {
//#ifdef DEBUG
//            NSString *msg = infoDic[NSLocalizedFailureReasonErrorKey];
//            NSLog(@"responseModel转换失败:%@",msg);
//#endif
//            return nil;
//        }
    }
    return self.description;
}

//- (NSString *)errorFormatData {
//    if ([self isKindOfClass:[NSError class]]) {
//        NSDictionary *infoDic = ((NSError *)self).userInfo;
//        NSString *msg = infoDic[NSLocalizedFailureReasonErrorKey];
//        if (msg.length) {
//            return msg;
//        }
//    }
//    return self.description;
//}

+ (NSError *)responseResultError:(CCResponseModel *)response {
    if ([response isKindOfClass:[CCResponseModel class]]) {
        NSError *error = [NSError errorWithDomain:@"TCFailureResult" code:response.code.integerValue userInfo:@{NSLocalizedDescriptionKey:response.msg?:@""}];
//        error.rtc_almightyObject = response;
        return error;
    }
    return nil;
}

//+ (NSError *)noNetworkError {
//    NSError *error = [NSError errorWithDomain:@"TCFailureNoNetwork" code:APIErrorCode_NoNetwork userInfo:@{NSLocalizedDescriptionKey:@"没有网络,请检查网络设置"}];
//    return error;
//}
//
//+ (NSError *)autoLoginFailError {
//    NSError *error = [NSError errorWithDomain:@"TCFailureAotuLogin" code:APIErrorCode_AutoLoginFail userInfo:@{NSLocalizedDescriptionKey:@"自动登录失败"}];
//    return error;
//}
//
//
//+ (NSError *)changeRoleFailError:(id)response {
//    NSError *error = [NSError errorWithDomain:@"TCFailureResult" code:APIErrorCode_ChangeRoleFail userInfo:@{NSLocalizedDescriptionKey:@"网络请求失败."}];
////    error.rtc_almightyObject = response;
//    return error;
//}
//
+ (NSError *)responseDataFormatError:(NSObject *)response {
    NSError *error = [NSError errorWithDomain:@"TCFailureResultDataFormatError" code:-1980 userInfo:@{NSLocalizedFailureReasonErrorKey:response.description?:@"DataFormatError"}];
    if ([response isKindOfClass:[NSObject class]]) {
//        error.rtc_almightyObject = response;
    }
    return error;
}
//
//+ (NSError *)loginInterceptErrorWithMsg:(NSString *)msg response:(id)response {
//    NSError *error = [NSError errorWithDomain:@"TCFailureLoginIntercept" code:APIErrorCode_LoginIntercept userInfo:@{NSLocalizedDescriptionKey:msg?:@"LoginIntercept"}];
//    if ([response isKindOfClass:[NSObject class]]) {
////        error.rtc_almightyObject = response;
//    }
//    return error;
//}

@end
