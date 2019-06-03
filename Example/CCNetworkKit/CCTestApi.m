//
//  CCTestApi.m
//  CCNetworkKit_Example
//
//  Created by 陈成 on 2019/5/13.
//  Copyright © 2019 chencheng2046@126.com. All rights reserved.
//

#import "CCTestApi.h"

@implementation CCTestApi
+ (CCBaseApi *)getWeatherDataWithVersion:(NSString *)version cityId:(NSString *)cityId {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (version) {
        [dic setObject:version forKey:@"version"];
    }
    if (cityId) {
        [dic setObject:cityId forKey:@"cityid"];
    }
    return  self.apiInitURLFull(@"https://www.tianqiapi.com/api/").l_params(dic).l_isGet(@(NO)).l_resArrayModelClass(NSArray.class);
}
@end
