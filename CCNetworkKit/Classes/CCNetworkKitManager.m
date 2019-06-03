//
//  CCHttpManager.m
//  wtf
//
//  Created by cc on 2018/3/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCNetworkKitManager.h"
@interface CCNetworkKitManager()
@property (nonatomic,strong) NSString *baseUrl;
@property (nonatomic,strong) NSString *codeName;
@property (nonatomic,strong) NSString *errMsgName;
@property (nonatomic,strong) NSString *serverTimeName;
@property (nonatomic,strong) NSString *dataName;

//未登录
@property (nonatomic,assign) NSInteger APIErrorCode_LoginNeeded;
//未登录的统一回调处理
@property (nonatomic,copy) void (^ErrLoginNeededBlock)(void);
//登录超时
@property (nonatomic,assign) NSInteger APIErrorCode_LoginOverdue;
//登录超时的统一回调处理
@property (nonatomic,copy) void (^ErrLoginOverdueBlock)(void);
//登录被挤或在其他设备登录
@property (nonatomic,assign) NSInteger APIErrorCode_LoginCrowd;
//登录被挤或在其他设备登录的统一回调处理
@property (nonatomic,copy) void (^ErrLoginCrowdBlock)(void);
@end

@implementation CCNetworkKitManager

+ (instancetype)shareManager{
    static CCNetworkKitManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)setBaseUrl:(NSString *)url {
    [CCNetworkKitManager shareManager].baseUrl = url;
}

+ (AFHTTPSessionManager *)getAFManager {
    return [self noneVerManager];
}

+ (void)registerCodeName:(NSString *)codeName errMsgName:(NSString *)errMsgName serverTimeName:(NSString *)serverTimeName dataName:(NSString *)dataName baseUrl:(NSString *)baseUrl {
    [CCNetworkKitManager shareManager].baseUrl = baseUrl;
    [CCNetworkKitManager shareManager].codeName = codeName;
    [CCNetworkKitManager shareManager].errMsgName = errMsgName;
    [CCNetworkKitManager shareManager].serverTimeName = serverTimeName;
    [CCNetworkKitManager shareManager].dataName = dataName;
}

+ (void)registerErrLoginNeededCode:(NSInteger)code {
    [CCNetworkKitManager shareManager].APIErrorCode_LoginNeeded = code;
}
+ (void)registerErrLoginOverdueCode:(NSInteger)code {
    [CCNetworkKitManager shareManager].APIErrorCode_LoginOverdue = code;
}
+ (void)registerErrLoginCrowdCode:(NSInteger)code {
    [CCNetworkKitManager shareManager].APIErrorCode_LoginCrowd = code;
}
+ (void)registerErrLoginNeededBlock:(void(^)(void))block {
    [CCNetworkKitManager shareManager].ErrLoginNeededBlock = block;
}

+ (void)registerErrLoginOverdueBlock:(void(^)(void))block {
    [CCNetworkKitManager shareManager].ErrLoginOverdueBlock = block;
}

+ (void)registerErrLoginCrowdBlock:(void(^)(void))block {
    [CCNetworkKitManager shareManager].ErrLoginCrowdBlock = block;
}
//http请求的单例对象 （此方法免https证书验证）
+ (AFHTTPSessionManager *)noneVerManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //允许非权威机构颁发的证书
        manager.securityPolicy.allowInvalidCertificates = YES;
        //也不验证域名一致性
        manager.securityPolicy.validatesDomainName = NO;
        manager.requestSerializer.timeoutInterval = cHttpRequestTimeoutInterval;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"text/javascript",nil];
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    });
    return manager;
}

//https证书单向验证 （缺少服务器端证书库文件） <tuck-mark>
+ (AFHTTPSessionManager *)oneWayVerManager:(NSString *)baseUrl {
    static AFHTTPSessionManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        shareInstance = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] sessionConfiguration:configuration];
        //设置请求参数的类型:JSON
        shareInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
        shareInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        //设置请求的超时时间
        shareInstance.requestSerializer.timeoutInterval = cHttpRequestTimeoutInterval;
        //设置ContentType
        shareInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"text/javascript",nil];

        //https配置
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"sclp" ofType:@"p12"];//这里应该用服务器端的证书库文件 <tuck-mark>
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        NSSet *dataSet = [[NSSet alloc] initWithObjects:certData, nil]; //这里可以添加多个server的证书
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:dataSet];
        // setPinnedCertificates 设置证书文件（可能不止一个证书）
        //[securityPolicy setPinnedCertificates:dataSet];
        // allowInvalidCertificates 是否允许无效证书
        [securityPolicy setAllowInvalidCertificates:NO];
        // validatesDomainName 是否需要验证域名
        [securityPolicy setValidatesDomainName:YES];
        shareInstance.securityPolicy = securityPolicy;
    });
    return shareInstance;
}

/*
 *
 **
 * 创建服务器信任客户端的认证条件 //https证书双向验证 （缺少服务器端证书库文件）
 **
 */
+ (AFHTTPSessionManager *)bothWayVerManager:(NSString *)baseUrl {
    __block AFHTTPSessionManager * manager = [self oneWayVerManager:baseUrl];
    __weak typeof(manager) weakManager = manager;
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition =NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"sclp"ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:p12]) {
                NSLog(@"client.p12:not exist");
            } else {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                //#加载PKCS12证书，pfx或p12
                if ([self extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data]) {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition =NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
    return manager;
}

/**
 **加载PKCS12证书，pfx或p12
 **
 **/
+(BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"kadiwuliu" forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}
//getter

@end
