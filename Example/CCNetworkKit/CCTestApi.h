//
//  CCTestApi.h
//  CCNetworkKit_Example
//
//  Created by 陈成 on 2019/5/13.
//  Copyright © 2019 chencheng2046@126.com. All rights reserved.
//

#import <CCNetworkKit/CCBaseApi.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCTestApi : CCBaseApi
+ (CCBaseApi *)getWeatherDataWithVersion:(NSString *)version cityId:(NSString *)cityId;
@end

NS_ASSUME_NONNULL_END
