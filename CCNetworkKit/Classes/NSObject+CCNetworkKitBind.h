//
//  NSObject+RTCObjectBind.h
//  KDLogistics
//
//  Created by cc on 2017/12/29.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//typedef void (^AlmightyBlock) (NSObject *object,id primitiveType,id delegate);

@interface NSObject (CCNetworkKitBind)

//@property (nonatomic,copy) NSString *rtc_reuseIdentifier;

//@property (nonatomic,strong) NSIndexPath *rtc_feedIndexPath;

//@property (nonatomic,assign) Class rtc_cellClass;

//@property (nonatomic,strong) NSObject *rtc_almightyObject;

//@property (nonatomic,assign) id rtc_almightyWeakObject;

//@property (nonatomic,copy) AlmightyBlock rtc_almightyBlock;

@property (nonatomic, copy) dispatch_block_t rtc_deallocExecutedBlock;

//@property (nonatomic, assign) BOOL rtc_isNotLeakObject;


/**
 对象绑定
 
 @param object 要绑定的对象
 @param key 绑定对象的key
 */
//- (void)rtc_bindObject:(id)object forKey:(NSString *)key;
//
//- (void)rtc_bindWeakObject:(id)object forKey:(NSString *)key;
//
//- (void)rtc_bindBlock:(id)block forKey:(NSString *)key;

/**
 获取已绑定的对象

 @param key 绑定对象的key
 @return 绑定的对象，没有则为nil
 */
//- (id)rtc_fetchObjectWithKey:(NSString *)key;
//
//- (void)rtc_bindByClassWithObject:(NSObject *)object;
//- (NSObject *)rtc_fetchObjectFromClass:(Class)clazz;

@end
