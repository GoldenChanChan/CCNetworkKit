//
//  CCBaseApi.h
//  KDLogistics
//
//  Created by cc on 2017/12/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNetworkKitManager.h"
#import "CCResponseModel.h"

@class CCBaseApi;
@protocol l_resModelClass;
@protocol l_resArrayModelClass;

typedef NSError * (^InterceptorBlock) (id response);  //接口返回成功数据处理拦截器
typedef void (^SuccessBlock) (id response);
typedef void (^FinishBlock) (id response,NSError * error);
typedef void (^MultipartBlock) (id<AFMultipartFormData> formData);  //上传文件使用
typedef CCBaseApi<l_resModelClass,l_resArrayModelClass> *(^CCBaseApiBasicBlockType)(id);
typedef CCBaseApi *(^CCBaseApiClassParamBlockType)(Class);

//这里分别创建两个设置接收对象的协议，为了避免CCBaseApi实例同时调用这两个方法
@protocol l_resModelClass <NSObject>
//设置接收对象的class
- (CCBaseApiClassParamBlockType) l_resModelClass;
@end

@protocol l_resArrayModelClass <NSObject>
//设置接收的数组对象的class
- (CCBaseApiClassParamBlockType)l_resArrayModelClass;
@end

@interface CCBaseApi : NSObject
//初始化
+(CCBaseApiBasicBlockType)apiInitURLFull;
//设置loading ui 的父视图
- (CCBaseApiBasicBlockType) l_loadOnView;
//保存调用接口的对象，用于在销毁时做一下清除操作
- (CCBaseApiBasicBlockType) l_delegate;
//FXDataListModel中的rows对应的model
//- (CCBaseApiClassParamBlockType) l_dataListRowsModelClass;
//接口返回成功数据处理拦截器block
- (CCBaseApiBasicBlockType) l_interceptorBlock;
//上传文件所使用的block
- (CCBaseApiBasicBlockType) l_multipartBlock;
//上传文件的个数
- (CCBaseApiBasicBlockType) l_filesCount;
//接口参数设置
- (CCBaseApiBasicBlockType) l_params;

/*以下两个方法共存时，以最后调用的方法为最终的参数设置*/
//自定义判定成功结果的code，不传或传nil会使用默认code:1
- (CCBaseApiBasicBlockType) l_successCode;
//自定义判定成功结果的code数组，不传或传nil会使用默认code:1
- (CCBaseApiBasicBlockType) l_successCodeArray;

/*设置回调并执行请求*/
//只有请求成功才会执行回调
-(void (^)(SuccessBlock))apiCallSuccess;
//含请求成功和失败
-(void (^)(FinishBlock))apiCall;

/**
 重新调用该接口的请求，不需要调用
 */
- (void)POST;

//失败处理，不需要调用
- (void)handleError:(NSError *)error;
//取消请求
- (void)cancel;
@end
