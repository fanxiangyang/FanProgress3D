//
//  FanProgress3D.h
//  FirstAF
//
//  Created by qianfeng on 14-10-24.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

/*
 版本1.0，2014-10-24
 1.可以根据自己的需要，自己去改颜色，和label颜色
 2.提示信息，title不易太长，尽量20字以下
 
 
 更新：1.优化动画部分
 */




#import <UIKit/UIKit.h>


@interface FanProgress3D : UIView
//正在加载，在那个View上
+ (void)showInView:(UIView*)view status:(NSString*)string;
//消失
+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation
//几秒后消失（包括成功和失败都可以调用）
+ (void)dismissWithStatus:(NSString *)string afterDelay:(NSTimeInterval)seconds;

@end
