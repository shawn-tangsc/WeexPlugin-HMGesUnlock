//
//  HMUnlockView.h
//  WeexEros
//
//  Created by 唐嗣成 on 2018/1/28.
//  Copyright © 2018年 benmu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    YWUnlockViewCreate,//创建手势密码
    YWUnlockViewUnlock//解锁手势密码
} YWUnlockViewType;

/** 回调 result: 操作是否成功 */
typedef void(^CallBackBlock)(BOOL result);


@interface HMUnlockView : UIView

/** 是否已经创建过手势密码 */
+ (BOOL)haveGesturePassword;

/** 获取手势密码 */
+ (NSString *)getGesturesPassword;

/** 删除手势密码 */
+ (void)deleteGesturesPassword;

/**
 展示 手势密码视图
 @param type 类型 (YWUnlockViewCreate,//创建手势密码 YWUnlockViewUnlock//解锁手势密码)
 */
+ (void)showUnlockViewWithType:(YWUnlockViewType)type callBack:(CallBackBlock)callBack;

+ (void)hideUnlockView;


@end
