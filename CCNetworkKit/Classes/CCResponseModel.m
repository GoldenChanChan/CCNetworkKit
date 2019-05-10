//
//  CCResponseModel.m
//  Pods
//
//  Created by 陈成 on 2019/5/2.
//

#import "CCResponseModel.h"
#import <objc/runtime.h>
@implementation CCResponseModel
- (BOOL)isSuccessResult {
    return self.code.integerValue == 1;
    //    return self.code.integerValue == kDefaultSuccessCode.integerValue;
}

- (BOOL)isSuccessResultWithCodes:(NSArray *)codes {
    return self.code && codes.count && [codes containsObject:self.code];
}

+ (void)replaceDataPropertyTypeWithClass:(Class)mClass isArray:(BOOL)isArray {
    Class clazz = [self class];
    objc_removeAssociatedObjects(clazz);
    NSString *className = nil;
    NSString *protocol = nil;
    if ([mClass isSubclassOfClass:clazz]) {
        className = @"NSObject";
        protocol = @"<Ignore>";
    } else {
        if (isArray) {
            className = NSStringFromClass(NSArray.class);//这里暂未扩展NSMutableArray，基本不会需要
            NSString *protocolName = NSStringFromClass(mClass);
            protocol = [NSString stringWithFormat:@"<%@><Optional>",protocolName];//不能用逗号拼接
        } else {
            className = NSStringFromClass(mClass);
            protocol = @"<Optional>";
        }
    }
    NSString *typeNew = [NSString stringWithFormat:@"@\"%@%@\"",className,protocol];
    objc_property_attribute_t type = {"T", [typeNew UTF8String]};
    objc_property_attribute_t strong = {"&", ""};
    objc_property_attribute_t nonatomic = {"N", ""};
    objc_property_attribute_t ivar = {"V", "_data"};
    objc_property_attribute_t attributes[] = {type, strong, nonatomic, ivar};
    class_replaceProperty(clazz, "data", attributes, 4);
    /*
     unsigned int outCount = 0;
     objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
     for(int i = 0; i < outCount; i++){
     unsigned int count = 0;
     objc_property_attribute_t *attributes = property_copyAttributeList(properties[i], &count);
     for(int j = 0; j < count; j++){
     NSLog(@"attribute.name = %s, attribute.value = %s", attributes[j].name, attributes[j].value);
     }
     }
     */
}





#pragma mark --- 由于NSArray不建议被继承，所以下面代码无用了，留作参考
/*
 - (void)codeMark {
 if (![className isEqualToString:@"NSArray"]&&![className isEqualToString:@"NSMutableArray"]&&[mClass isSubclassOfClass:NSArray.class]) {
 NSString* selectorName = [NSString stringWithFormat:@"%@FromNSArray:",className];
 SEL selector = NSSelectorFromString(selectorName);
 //SEL impSel = NSSelectorFromString(@"transformJSONValue:");//对应的JSONValueTransformer分类已删除
 //class_addMethod(JSONValueTransformer.class, selector, class_getMethodImplementation(JSONValueTransformer.class, impSel), "@@:@");
 class_addMethod(JSONValueTransformer.class, selector, (IMP)transformJSONValue, "@@:@");
 unsigned int count;
 Protocol * __unsafe_unretained *list = class_copyProtocolList(mClass, &count);
 for (int i = 0; i < count; i++) {
 Protocol *pro = list[i];
 NSString *proName = NSStringFromProtocol(pro);
 DDLogVerbose(@"数组类遵循的协议～～～～～：%@",proName);
 protocol = [NSString stringWithFormat:@"<%@>%@",proName,protocol];
 }
 free(list);
 }
 }
 
 id transformJSONValue(id self, SEL _cmd, id value) {
 if (value&&[UploadFileApiResponseModel isSubclassOfClass:NSArray.class]) {
 return [UploadFileApiResponseModel arrayWithArray:value];
 }
 return nil;
 }
 */
@end
