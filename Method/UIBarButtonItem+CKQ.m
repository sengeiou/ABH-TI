//
//  UIBarButtonItem+MJ.m
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIBarButtonItem+CKQ.h"
#import <objc/runtime.h>
@implementation UIBarButtonItem (CKQ)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img=[UIImage imageNamed:icon];
   // CGSize size={img.size.width,img.size.height};
    UIImage *img1=[UIImage imageNamed:highIcon];
    //CGSize size1={img1.size.width,img1.size.height};
    
    [button setBackgroundImage:img forState:UIControlStateNormal];
    
    //[button setBackgroundImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    [button setBackgroundImage:img1 forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)backItemWithTarget:(id)target Hidden:(BOOL)hidden action:(SEL)action
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =CGRectMake(0, 0, 25, 22);
    backButton.hidden = hidden;
    if ([[[UIDevice currentDevice]systemVersion] doubleValue]>=7.0) {
        [backButton setImage:[[UIImage imageNamed:@"love_nav_back_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"love_nav_back_button"]  forState:UIControlStateNormal];
    }
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
@end
