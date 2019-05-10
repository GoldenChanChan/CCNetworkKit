//
//  CCBaseApi.m
//  KDLogistics
//
//  Created by fengunion on 2017/12/14.
//  Copyright © 2017年 fengunion. All rights reserved.
//

#import "CCBaseApi.h"
#import "NSError+CCNetworkKit.h"
#import "NSObject+CCNetworkKitBind.h"
#import "UIView+CCNetToast.h"

@interface CCBaseApi()<l_resModelClass,l_resArrayModelClass>
//resModelClass可传入JsonModel子类或者NSObject(string,array,dictionry,number等等)基本类型,不能传入自定义的类
//返回数据中的data对应的class，当返回对象为数组时，对应数组内的对象类型
@property (nonatomic,assign) Class resModelClass;
//返回数据中的data对应的rows的class，当返回对象为数组时，对应数组内的对象类型
@property (nonatomic,assign) Class rowsModelClass;
@property (nonatomic,copy) NSString *URLFull;
@property (nonatomic,copy) InterceptorBlock interceptorBlock;
@property (nonatomic,copy) SuccessBlock successBlock;
@property (nonatomic,copy) FinishBlock finishBlock;
@property (nonatomic,copy) MultipartBlock multipartBlock;
@property (nonatomic,strong) UIView *loadOnView;
@property (nonatomic,strong) NSMutableDictionary *params;
@property (nonatomic,assign) NSUInteger filesCount;
@property (nonatomic,copy) NSString *successCode;
@property (nonatomic,strong) NSArray *successCodeArray;
@property (nonatomic,assign) id delegate;
@property (nonatomic,strong) NSURLSessionDataTask *httpTask;
@property (nonatomic,assign) BOOL isResArray;//返回的data数据是否为数组
@property (nonatomic,assign) BOOL isRequesting;//是否正在请求中
@property (nonatomic,strong) id httpResponseObject;//http返回的原始数据
@property (nonatomic,strong) CCResponseModel *httpResultModel;//http返回数据转换成的modle
@property (nonatomic,strong) id httpResultDataModel;//http返回数据转换成的modle中的data对象
@property (nonatomic,strong) NSError *httpError;
@end


@implementation CCBaseApi

+(CCBaseApi *)apiInit {
    CCBaseApi *api = [[self.class alloc] init];
    api.resModelClass = CCResponseModel.class;
    api.rowsModelClass = NSArray.class;
    return api;
}

+(CCBaseApiBasicBlockType)apiInitURLFull {
    return ^(NSString * apiInitURLFull){
        return [self apiInit].l_URLFull(apiInitURLFull);
    };
}

-(CCBaseApiBasicBlockType)l_loadOnView {
    return ^(UIView * l_loadOnView){
        self.loadOnView = l_loadOnView;
        return self;
    };
}
-(CCBaseApiBasicBlockType)l_delegate {
    return ^(id l_delegate){
        self.delegate = l_delegate;
        return self;
    };
}

/*
-(CCBaseApi * (^)(Class))l_rowsModelClass {
    return ^(Class l_rowsModelClass){
        self.rowsModelClass = l_rowsModelClass;
        return self;
    };
}
*/

//-(CCBaseApiClassParamBlockType)l_dataListRowsModelClass {
//    return ^(Class l_dataListRowsModelClass){
//        self.resModelClass = FXDataListModel.class;
//        self.rowsModelClass = l_dataListRowsModelClass;
//        self.isResArray = NO;
//        return self;
//    };
//}

-(CCBaseApiClassParamBlockType)l_resModelClass {
    return ^(Class l_resModelClass){
        self.resModelClass = l_resModelClass;
        self.isResArray = NO;
        return self;
    };
}

-(CCBaseApiClassParamBlockType)l_resArrayModelClass {
    return ^(Class l_resArrayModelClass){
        self.resModelClass = l_resArrayModelClass;
        self.isResArray = YES;
        return self;
    };
}


-(CCBaseApi<l_resModelClass,l_resArrayModelClass> * (^)(id))l_interceptorBlock {
    return ^(InterceptorBlock l_interceptorBlock){
        self.interceptorBlock = l_interceptorBlock;
        return self;
    };
}

//-(CCBaseApi * (^)(SuccessBlock))l_successBlock {
//    return ^(SuccessBlock l_successBlock){
//        self.successBlock = l_successBlock;
//        return self;
//    };
//}

//-(CCBaseApi * (^)(SuccessVoidBlock))l_successVoidBlock {
//    return ^(SuccessVoidBlock l_successVoidBlock){
//        self.successVoidBlock = l_successVoidBlock;
//        return self;
//    };
//}

//-(CCBaseApi * (^)(FailureBlock))l_failureBlock {
//    return ^(FailureBlock l_failureBlock){
//        self.failureBlock = l_failureBlock;
//        return self;
//    };
//}

-(CCBaseApiBasicBlockType)l_multipartBlock {
    return ^(MultipartBlock l_multipartBlock){
        self.multipartBlock = l_multipartBlock;
        return self;
    };
}

-(CCBaseApiBasicBlockType)l_params {
    return ^(NSMutableDictionary *l_params){
        self.params = l_params;
        return self;
    };
}

-(CCBaseApiBasicBlockType)l_filesCount {
    return ^(NSNumber *l_filesCount){
        self.filesCount = l_filesCount.integerValue;
        return self;
    };
}

//设置url
-(CCBaseApiBasicBlockType)l_URLFull {
    return ^(NSString *l_URLFull){
        self.URLFull = [NSString stringWithFormat:@"%@%@",CCNetworkKitManager.shareManager.baseUrl,l_URLFull];
        return self;
    };
}

-(CCBaseApiBasicBlockType)l_successCode {
    return ^(NSString *l_successCode){
        self.successCode = l_successCode;
        if (self.successCode) {
            self.successCodeArray = @[self.successCode];
        } else {
            self.successCodeArray = nil;
        }
        return self;
    };
}

-(CCBaseApiBasicBlockType)l_successCodeArray {
    return ^(NSArray *l_successCodeArray){
        self.successCodeArray = l_successCodeArray;
        return self;
    };
}

-(void(^)(FinishBlock))apiCall {
    return ^(FinishBlock l_finishBlock){
        self.finishBlock = l_finishBlock;
        [self preparePost];
//        return self;
    };
}

-(void(^)(SuccessBlock))apiCallSuccess {
    return ^(SuccessBlock l_successBlock){
        self.successBlock = l_successBlock;
        [self preparePost];
//        return self;
    };
}

//-(CCBaseApi * (^)(SuccessVoidBlock))apiCallSuccessVoid {
//    return ^(SuccessVoidBlock l_successVoidBlock){
//        self.successVoidBlock = l_successVoidBlock;
//        [self preparePost];
//        return self;
//    };
//}

- (void)preparePost {
    [self propertyReset];
    [self POST];
}

- (void)propertyReset {
    _httpTask = nil;
    _isRequesting = NO;
    _httpResponseObject = nil;
    _httpResultModel = nil;
    _httpResultDataModel = nil;
    _httpError = nil;
}

- (CCResponseModel *)makeApiResultModel {
    CCResponseModel *model = nil;
    NSError *error = nil;
    if (self.resModelClass) {
        @synchronized (self) {
            [CCResponseModel replaceDataPropertyTypeWithClass:self.resModelClass isArray:self.isResArray];
//            if (self.rowsModelClass) {
//                [FXDataListModel replaceDataPropertyTypeWithClass:self.rowsModelClass];
//            }
            model = [[CCResponseModel alloc] initWithDictionary:self.httpResponseObject error:&error];
        }
#ifdef DEBUG
        if (error) NSLog(@"CCBaseCCResponseModel转换失败:  %@", error.description);
#endif
    }
    _httpResultModel = model;
    _httpResultDataModel = model.data;
    return model?:self.httpResponseObject;
}


/**
 处理http返回结果

 @param response http返回结果
 */
- (void)handleResponse:(id)response {
    _httpResponseObject = response;
    //映射根json结构
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *newResponse = [NSMutableDictionary new];
        //设置状态码字段数据
        NSString *codeName = CCNetworkKitManager.shareManager.codeName;
        if (codeName&&[response objectForKey:codeName]) {
            [newResponse setObject:[response objectForKey:codeName] forKey:codeName];
        }
        //设置错误信息字段数据
        NSString *msgName = CCNetworkKitManager.shareManager.errMsgName;
        if (msgName&&[response objectForKey:msgName]) {
            [newResponse setObject:[response objectForKey:msgName] forKey:msgName];
        }
        //设置服务器时间字段数据
        NSString *serverTimeName = CCNetworkKitManager.shareManager.serverTimeName;
        if (serverTimeName&&[response objectForKey:serverTimeName]) {
            [newResponse setObject:[response objectForKey:serverTimeName] forKey:serverTimeName];
        }
        //设置接口数据源字段数据
        NSString *dataName = CCNetworkKitManager.shareManager.dataName;
        if (dataName&&[response objectForKey:dataName]) {
            [newResponse setObject:[response objectForKey:dataName] forKey:dataName];
        }
        if (newResponse.allKeys.count) {
            _httpResponseObject = newResponse;
        }
    }
    
#ifdef DEBUG
    NSLog(@"http responseObject:  %@", response);
#endif
    NSError *error = nil;
    CCResponseModel *resModel = [self makeApiResultModel];
    if ([resModel isKindOfClass:CCResponseModel.class]) {
        bool isSuccessResult = self.successCodeArray.count?[resModel isSuccessResultWithCodes:self.successCodeArray]:resModel.isSuccessResult;
        if (isSuccessResult) {
            [self handleSuccess];
            return;
        } else {
            error = [NSError responseResultError:resModel];
            if (error.code==CCNetworkKitManager.shareManager.APIErrorCode_LoginOverdue) {
                //登录超时
                if (CCNetworkKitManager.shareManager.ErrLoginOverdueBlock) {
                    CCNetworkKitManager.shareManager.ErrLoginOverdueBlock();
                }
            } else if (error.code==CCNetworkKitManager.shareManager.APIErrorCode_LoginNeeded) {
                //未登录
                if (CCNetworkKitManager.shareManager.ErrLoginNeededBlock) {
                    CCNetworkKitManager.shareManager.ErrLoginNeededBlock();
                }
            } else if (error.code==CCNetworkKitManager.shareManager.APIErrorCode_LoginCrowd) {
                //账号被挤或在其他地方登录了
                if (CCNetworkKitManager.shareManager.ErrLoginCrowdBlock) {
                    CCNetworkKitManager.shareManager.ErrLoginCrowdBlock();
                }
            }
        }
    } else {
        if (!self.resModelClass) {
            [self handleSuccess];//这里可以返回原始字典结果
            return;
        }
        error = [NSError responseDataFormatError:resModel];
    }
    if (error) {
        [self handleError:error];
    }
}

- (void)handleSuccess {
    _isRequesting = NO;
    
    id resultModel = self.httpResultModel;
    if (!self.resModelClass) {
        //如果将返回数据的class设为nil，返回原始字典数据
        resultModel = self.httpResponseObject;
    } else {
        //传入了data的class类型，必须返回data数据，即使data为nil
        if (![self.resModelClass isSubclassOfClass:CCResponseModel.class]) {
            resultModel = self.httpResultDataModel;
        }
    }
    
    if (self.interceptorBlock) {
        NSError *error = self.interceptorBlock(resultModel);
        if (error) {
            [self handleError:error];
            return;
        }
    }
    
    if (self.loadOnView) {
        [self.loadOnView toastHide];
    }

//    if (self.successVoidBlock) {
//        self.successVoidBlock();
//    }
    if (self.successBlock) {
        self.successBlock(resultModel);
    }
    if (self.finishBlock) {
        self.finishBlock(resultModel,nil);
    }
}

- (void)handleError:(NSError *)error {
    _isRequesting = NO;
#ifdef DEBUG
    NSLog(@"http error:  %@", error);
#endif
    if (self.loadOnView) {
        [self.loadOnView toastHide];
        [[UIApplication sharedApplication].keyWindow toastError:error.errorMessage];
    }
    _httpError = error;
//    if (self.failureBlock) {
//        self.failureBlock(error);
//    }
    if (self.finishBlock) {
        self.finishBlock(nil,error);
    }
}

- (BOOL)isHttpCanRequest {
//    if(![ApiHelperSingleton sharedInstance].isOnLine) {
//        [self handleError:[NSError noNetworkError]];
//        return NO;
//    }
    return YES;
}

//普通请求都是单个请求，图片上传是多个图片一起上传，需要设置更长的超时时间
- (void)setupHttpHeaderAndRequestTimeout {
    AFHTTPSessionManager *manager = [CCNetworkKitManager getAFManager];
    manager.requestSerializer.timeoutInterval = cHttpRequestTimeoutInterval*(self.filesCount>1?self.filesCount:1);
//    NSString *token = [FXCoreDataManager sharedInstance].userModel.token;
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
}

- (void)POST {
#ifdef DEBUG
    NSLog(@"POST调用接口 %@",self.URLFull);
#endif
    if (![self isHttpCanRequest]) return;
    
    if (self.loadOnView) {
        [self.loadOnView toastLoading];
    }
    _isRequesting = YES;
    
    [self setupHttpHeaderAndRequestTimeout];
    if (!self.params) {
        self.params = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *postParams = [self.params mutableCopy];
#ifdef DEBUG
    NSLog(@"Request header: %@\n path: %@\n params: %@",[CCNetworkKitManager getAFManager].requestSerializer.HTTPRequestHeaders , self.URLFull, postParams);
#endif
    //上传进度回调
    void (^progress)(NSProgress * _Nonnull)  = ^(NSProgress *uploadProgress) {
        //DDLogVerbose(@"图片上传进度: %f", uploadProgress.fractionCompleted);
    };
    //下面的block中需要用self，延长实例生命周期
    void (^success)(NSURLSessionDataTask *_Nullable, id _Nullable)  = ^(NSURLSessionDataTask *task, id response) {
        [self handleResponse:response];
    };
    //失败的回调
    void (^failure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull)  = ^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error];
    };
    
    if (self.multipartBlock) {
        _httpTask = [[CCNetworkKitManager getAFManager] POST:self.URLFull parameters:postParams constructingBodyWithBlock:self.multipartBlock progress:progress success:success failure:failure];
    } else {
        _httpTask = [[CCNetworkKitManager getAFManager] POST:self.URLFull parameters:postParams progress:progress success:success failure:failure];
    }
    [self autoCancelTask];
}

- (void)autoCancelTask {
    //调用http请求的发起者对象销毁后，取消未完成的http请求
    if (self.delegate && [self.delegate isKindOfClass:[NSObject class]]) {
        NSObject *object = self.delegate;
        __weak typeof(self) weakSelf = self;
        object.rtc_deallocExecutedBlock = ^{
            if (weakSelf.httpTask
                && weakSelf.httpTask.state != NSURLSessionTaskStateCompleted) {
                [weakSelf.httpTask cancel];
#ifdef DEBUG
                NSLog(@"取消了一个请求");
#endif
            }
        };
    }
}

- (void)cancel {
    [self.httpTask cancel];
}

//登录状态失效后，app自动登录
//- (void)autoRelogin {
//#ifdef DEBUG
//    [self.appWindow toastWithText:@"登录状态失效，App自动登录"];
//#endif
//    [[ApiHelperSingleton sharedInstance] addApi:self];
//    if (![ApiHelperSingleton sharedInstance].isWaitingLogin) {
//        [ApiHelperSingleton sharedInstance].isWaitingLogin = YES;
//        CCBaseApi *loginApi = CTMediator.sharedInstance.performSEL(@"autoReloginApi");//获取到登录的api对象
//        if (loginApi) {
//            loginApi.l_loadOnView(nil).apiCall(^(id res,NSError *error) {
//                if (error) {
//                    //自动登录失败，跳转到登录界面
//                    [self logoutToLoginVC];
//                } else {
//                    //自动登录成功
//                    CTMediator.sharedInstance.performSEL_O(@"loginSuccessed:",res);
//                }
//                if ([ApiHelperSingleton sharedInstance].apiArray.count>0) {
//                    [[ApiHelperSingleton sharedInstance] finishLoginSuccessed:(error==nil)];
//                } else {
//                    [self.loadOnView toastHide];
//                }
//            });
//        }
//    }
//}

//判断是否已登录
//- (BOOL)isLogined {
//    BOOL isLogin = [CTMediator.sharedInstance.performSEL(@"isLogin") boolValue];
//    return isLogin;
//}

//退出登录并跳转到登录界面
//- (void)logoutToLoginVC {
//    [self.loadOnView toastHide];
//    CTMediator.sharedInstance.performSEL(@"logoutToLogin");
//    [self.appWindow toastWithText:@"登录状态失效，请重新登录!"];
//}

//账号被挤，弹出alert，点击后跳转至登录界面
//- (void)loginCrowded:(CCResponseModel *)resModel {
//    static BOOL isLoginCrowdedAlertShowing = NO;
//    if (!isLoginCrowdedAlertShowing) {
//        isLoginCrowdedAlertShowing = YES;
//        //账号被挤，提示alert,点击确定，跳转到登录界面
//        CTMediator.sharedInstance.performSEL(@"logout");
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:resModel.msg preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.topRootVC.navigationController popToRootViewControllerAnimated:NO];
//#pragma clang diagnostic ignored "-Wbool-conversion"
//            CTMediator.sharedInstance.performSEL_O(@"gotoLogin:",NO);
//            isLoginCrowdedAlertShowing = NO;
//        }];
//        [alert addAction:action];
//        [self.topRootVC presentViewController:alert animated:YES completion:nil];
//        if (!self.topRootVC) {
//            NSLog(@"账号被挤弹框未获取到toprootvc");
//        }
//    }
//}

@end
