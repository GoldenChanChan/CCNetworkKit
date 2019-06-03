//
//  CommonMethod.h
//  wtf
//
//  Created by cc on 2018/2/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#ifndef CommonMethod_h
#define CommonMethod_h

#import <objc/runtime.h>

static inline void tc_swizzle2InstanceSelector(Class originalClass, Class swizzledClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    if (class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(originalClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static inline void tc_swizzleSelector(Class clazz, SEL originalSelector, SEL swizzledSelector) {
    tc_swizzle2InstanceSelector(clazz, clazz, originalSelector, swizzledSelector);
}


static inline void tc_swizzle2ClassSelector(Class originalClass, Class swizzledClass, SEL originalSelector, SEL swizzledSelector) {
    Class originalMetaClass = object_getClass(originalClass);
    Method originalMethod = class_getClassMethod(originalMetaClass, originalSelector);
    Method swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
    //const char *clsName = class_getName(clazz);
    //Class metaClass = objc_getMetaClass(clsName);
    if (class_addMethod(originalMetaClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(originalMetaClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static inline void tc_swizzleClassSelector(Class clazz, SEL originalSelector, SEL swizzledSelector) {
    tc_swizzle2ClassSelector(clazz, clazz, originalSelector, swizzledSelector);
}



#endif /* CommonMethod_h */
