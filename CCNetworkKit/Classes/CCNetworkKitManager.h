//
//  CCHttpManager.h
//  KDLogistics
//
//  Created by cc on 2018/3/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

static CGFloat const cHttpRequestTimeoutInterval = 15.0;

@interface CCNetworkKitManager : NSObject
//域名
@property (nonatomic,strong,readonly) NSString *baseUrl;

/*----------自定义的接口json结构解析规则中的字段名称，用于将http返回的数据转换为CCResponseModel可接收的字典格式--------*/
//状态码字段名称
@property (nonatomic,strong,readonly) NSString *codeName;
//错误信息字段名称
@property (nonatomic,strong,readonly) NSString *errMsgName;
//服务器时间字段名称
@property (nonatomic,strong,readonly) NSString *serverTimeName;
//数据源字段名称
@property (nonatomic,strong,readonly) NSString *dataName;


/*-----err code&solutionBlock-----*/
//未登录
@property (nonatomic,assign,readonly) NSInteger APIErrorCode_LoginNeeded;
//未登录的统一回调处理
@property (nonatomic,copy,readonly) void (^ErrLoginNeededBlock)(void);
//登录超时
@property (nonatomic,assign,readonly) NSInteger APIErrorCode_LoginOverdue;
//登录超时的统一回调处理
@property (nonatomic,copy,readonly) void (^ErrLoginOverdueBlock)(void);
//登录被挤或在其他设备登录
@property (nonatomic,assign,readonly) NSInteger APIErrorCode_LoginCrowd;
//登录被挤或在其他设备登录的统一回调处理
@property (nonatomic,copy,readonly) void (^ErrLoginCrowdBlock)(void);


+ (instancetype)shareManager;
+ (AFHTTPSessionManager *)getAFManager;
+ (void)setBaseUrl:(NSString *)url;

/**
 注册将要解析的根数据的一级字段名（暂时支持四个字段的映射）

 @param codeName 返回的状态码字段名称
 @param errMsgName 返回的错误信息字段名称
 @param serverTimeName 返回的服务器时间字段名称
 @param dataName 返回的数据源字段名称
 @param baseUrl 设置请求接口的域名
 */
+ (void)registerCodeName:(NSString *)codeName errMsgName:(NSString *)errMsgName serverTimeName:(NSString *)serverTimeName dataName:(NSString *)dataName baseUrl:(NSString *)baseUrl;

/*--------------设置接口返回状态码 & 相关错误处理的回调---------------*/
/**
 设置d未登录的状态码
 
 @param code 状态码
 */
+ (void)registerErrLoginNeededCode:(NSInteger)code;
/**
 注册：未登录的错误处理的block

 @param block <#block description#>
 */
+ (void)registerErrLoginNeededBlock:(void(^)(void))block;

/**
 设置登录超时的状态码
 
 @param code 状态码
 */
+ (void)registerErrLoginOverdueCode:(NSInteger)code;
/**
 注册：登录超时的错误处理的block
 
 @param block <#block description#>
 */
+ (void)registerErrLoginOverdueBlock:(void(^)(void))block;
/**
 设置登录超时的状态码
 
 @param code 状态码
 */
+ (void)registerErrLoginCrowdCode:(NSInteger)code;
/**
 注册：登录被挤或在其他设备登录的错误处理的block
 
 @param block <#block description#>
 */
+ (void)registerErrLoginCrowdBlock:(void(^)(void))block;
//+ (AFHTTPSessionManager *)noneVerManager;//免https验证
//
//+ (AFHTTPSessionManager *)oneWayVerManager:(NSString *)baseUrl;//https单向验证
//
//+ (AFHTTPSessionManager *)bothWayVerManager:(NSString *)baseUrl;//https双向验证

@end
