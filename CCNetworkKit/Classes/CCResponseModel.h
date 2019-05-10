//
//  CCResponseModel.h
//  Pods
//
//  Created by 陈成 on 2019/5/2.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCResponseModel : JSONModel
@property (nonatomic, copy) NSString <Optional>*code;
@property (nonatomic, copy) NSString <Optional>*msg;
@property (nonatomic, copy) NSString <Optional>*currentTime;
//运行时改变属性类型
@property (nonatomic, strong) NSObject<Ignore> *data;

//原始字典数据
@property (nonatomic, strong) NSDictionary<Ignore> *dictionary;

//用来绑定一些特殊回传对象
@property (nonatomic, strong) NSObject<Ignore> *postbackObject;

- (BOOL)isSuccessResult;

- (BOOL)isSuccessResultWithCodes:(NSArray *)codes;

+ (void)replaceDataPropertyTypeWithClass:(Class)mClass isArray:(BOOL)isArray;
@end

NS_ASSUME_NONNULL_END
