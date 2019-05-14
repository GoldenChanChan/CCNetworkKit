//
//  CCViewController.m
//  CCNetworkKit
//
//  Created by chencheng2046@126.com on 05/02/2019.
//  Copyright (c) 2019 chencheng2046@126.com. All rights reserved.
//

#import "CCViewController.h"
#import "CCTestApi.h"
//#import <CCNetworkKit/UIView+CCNetToast.h>

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getTestRequest];
}
- (void)getTestRequest {
    [CCTestApi getWeatherDataWithVersion:@"v1" cityId:@"101110101"].l_loadOnView(self.view).apiCall(^(id result,NSError* err){
        NSLog(@"%@",result);
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
