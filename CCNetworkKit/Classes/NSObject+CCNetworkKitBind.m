//
//  NSObject+RTCObjectBind.m
//  KDLogistics
//
//  Created by cc on 2017/12/29.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "NSObject+CCNetworkKitBind.h"
#import "CCNetWorkKitSwizzling.h"

@implementation NSObject (CCNetworkKitBind)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clazz = [self class];
        tc_swizzleSelector(clazz, NSSelectorFromString(@"dealloc"), @selector(rtc_dealloc));
#ifdef DEBUG
//        tc_swizzleSelector(clazz, NSSelectorFromString(@"willDealloc"), @selector(rtc_willDealloc));
#endif
    });
}

//- (BOOL)rtc_willDealloc {
//    if(self.rtc_isNotLeakObject) {
//        return NO;
//    }
//    return [self rtc_willDealloc];
//}

- (void)rtc_dealloc {
    if (self.rtc_deallocExecutedBlock) {
        self.rtc_deallocExecutedBlock();
    }
    [self rtc_dealloc];
}

//- (BOOL)rtc_isNotLeakObject {
//    NSNumber *leak = objc_getAssociatedObject(self, _cmd);
//    if (!leak) {
//        return NO;
//    }
//    return leak.boolValue;
//}
//
//- (void)setRtc_isNotLeakObject:(BOOL)rtc_isNotLeakObject {
//    objc_setAssociatedObject(self, @selector(rtc_isNotLeakObject), @(rtc_isNotLeakObject), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//- (NSString *)rtc_reuseIdentifier {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setRtc_reuseIdentifier:(NSString *)rtc_reuseIdentifier {
//    objc_setAssociatedObject(self, @selector(rtc_reuseIdentifier), rtc_reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

//- (NSIndexPath *)rtc_feedIndexPath {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setRtc_feedIndexPath:(NSIndexPath *)rtc_feedIndexPath {
//    objc_setAssociatedObject(self, @selector(rtc_feedIndexPath), rtc_feedIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//- (Class)rtc_cellClass {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setRtc_cellClass:(Class)rtc_cellClass {
//    NSString *className = NSStringFromClass(rtc_cellClass);
//    NSString *classNameRel = [className componentsSeparatedByString:@"."].lastObject;
//    if (!self.rtc_reuseIdentifier) {
//        self.rtc_reuseIdentifier = classNameRel;
//    }
//    objc_setAssociatedObject(self, @selector(rtc_cellClass), rtc_cellClass, OBJC_ASSOCIATION_ASSIGN);
//}

//- (NSObject *)rtc_almightyObject {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setRtc_almightyObject:(NSObject *)rtc_almightyObject {
//    objc_setAssociatedObject(self, @selector(rtc_almightyObject), rtc_almightyObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//- (id)rtc_almightyWeakObject {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setRtc_almightyWeakObject:(id)rtc_almightyWeakObject {
//    objc_setAssociatedObject(self, @selector(rtc_almightyWeakObject), rtc_almightyWeakObject, OBJC_ASSOCIATION_ASSIGN);
//}

//- (AlmightyBlock)rtc_almightyBlock {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setRtc_almightyBlock:(AlmightyBlock)rtc_almightyBlock {
//    objc_setAssociatedObject(self, @selector(rtc_almightyBlock), rtc_almightyBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

- (dispatch_block_t)rtc_deallocExecutedBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRtc_deallocExecutedBlock:(dispatch_block_t)rtc_deallocExecutedBlock {
    objc_setAssociatedObject(self, @selector(rtc_deallocExecutedBlock), rtc_deallocExecutedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//- (void)rtc_bindObject:(NSObject *)object forKey:(NSString *)key {
//    if ([self isNonEmptyString:key]) {
//        objc_setAssociatedObject(self, [key UTF8String], object, [object isKindOfClass:NSObject.class]?OBJC_ASSOCIATION_RETAIN_NONATOMIC:OBJC_ASSOCIATION_ASSIGN);
//    }
//}
//
//- (void)rtc_bindWeakObject:(id)object forKey:(NSString *)key {
//    if ([self isNonEmptyString:key]) {
//        objc_setAssociatedObject(self, [key UTF8String], object, OBJC_ASSOCIATION_ASSIGN);
//    }
//}
//
//- (id)rtc_fetchObjectWithKey:(NSString *)key {
//    if ([self isNonEmptyString:key]) {
//        return objc_getAssociatedObject(self, [key UTF8String]);
//    }
//    return nil;
//}
//
//- (void)rtc_bindBlock:(id)block forKey:(NSString *)key {
//    if ([self isNonEmptyString:key]) {
//        objc_setAssociatedObject(self, [key UTF8String], block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    }
//}
//
//- (void)rtc_bindByClassWithObject:(NSObject *)object {
//    NSString *className = NSStringFromClass(object.class);
//    NSString *classNameRel = [className componentsSeparatedByString:@"."].lastObject;
//    [self rtc_bindObject:object forKey:classNameRel];
//}
//
//- (NSObject *)rtc_fetchObjectFromClass:(Class)clazz {
//    NSString *className = NSStringFromClass(clazz);
//    NSString *classNameRel = [className componentsSeparatedByString:@"."].lastObject;
//    return [self rtc_fetchObjectWithKey:classNameRel];
//}
//
//- (BOOL)isNonEmptyString:(NSString *)str {
//    if (nil == str || NULL == str || [str isKindOfClass:[NSNull class]]) {
//        return NO;
//    }
//    if (![str isKindOfClass:[NSString class]]) {
//        return NO;
//    }
//    if (str.length==0) {
//        return NO;
//    }
//
//    return ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0);
//}

@end
