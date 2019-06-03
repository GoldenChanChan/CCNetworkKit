//
//  UIView+Toast.m
//  wtf
//
//  Created by cc on 2017/12/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UIView+CCNetToast.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"

#define kToastDuration 1.5

@implementation UIView (CCNetToast)

- (BOOL)isToastLoading {
    NSNumber *loading = objc_getAssociatedObject(self, _cmd);
    return loading.boolValue;
}

- (void)setIsToastLoading:(BOOL)isToastLoading {
    objc_setAssociatedObject(self, @selector(isToastLoading), @(isToastLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//toast是否会自动延迟隐藏
- (BOOL)isHudDelayHide {
    NSNumber *delayHide = objc_getAssociatedObject(self, _cmd);
    return delayHide.boolValue;
}

- (void)setIsHudDelayHide:(BOOL)isHudDelayHide {
    objc_setAssociatedObject(self, @selector(isHudDelayHide), @(isHudDelayHide), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)toastDefaultSetup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //设置toast默认样式
    });
}

- (void)toastWithText:(NSString *)text {
    [self toastWithText:text hideAfterDelay:kToastDuration];
}

- (void)toastWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    if (text.length>0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.contentColor = [UIColor whiteColor];
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:delay];
        hud.isHudDelayHide = YES;
    }
}

- (void)toastError:(NSString *)text {
    if (text.length>0) {
        [self toastWithText:text hideAfterDelay:kToastDuration];
    }
}

- (BOOL)noErrorToast:(NSError *)error {
    if (error) {
        [self toastError:error.description];
        return NO;
    } else {
        return YES;
    }
}

- (void)toastSucceed:(NSString *)text {
    [self toastWithText:text hideAfterDelay:kToastDuration];
}

- (void)toastLoading {
    if (self.isToastLoading) {
        return;
    }
    self.isToastLoading = YES;
    [self toastLoadingWithText:nil];
}

- (void)toastLoadingWithText:(NSString *)text {
    self.isToastLoading = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    if (text.length>0) {
        hud.label.text = text;
    }
}

- (void)toastHide {
    self.isToastLoading = NO;
    //[MBProgressHUD hideHUDForView:self animated:YES];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:MBProgressHUD.class]) {
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            if (!hud.isHudDelayHide) {
                [hud hideAnimated:YES];
            }
        }
    }
}



@end
