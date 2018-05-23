//
//  HMUnlockView.m
//  WeexEros
//
//  Created by 唐嗣成 on 2018/1/28.
//  Copyright © 2018年 benmu. All rights reserved.
//

#import "HMUnlockView.h"
#import "HMGesturesUnlockView.h"
#import "HMUnlockPreviewView.h"
#import "BMRouterModule.h"
#define GesturesPassword @"GesturesPassword"
#import <BMBaseLibrary/CommonMacro.h>
#import <BMBaseLibrary/BMDefine.h>
//当前屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//当前屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HMUnlock_KW [UIApplication sharedApplication].keyWindow
#define HMUnlock_BD [NSBundle mainBundle]
#define HMUnlock_WKSELF __weak __typeof(self)weakSelf = self
#define HMUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface HMUnlockView ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 绘制密码的状态label */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/** 重新绘制按钮 */
@property (weak, nonatomic) IBOutlet UIButton *resetGesturesPasswordButton;
/** 手势密码预览图 */
@property (weak, nonatomic) IBOutlet HMUnlockPreviewView *unlockPreviewView;
/** 手势密码绘制视图 */
@property (weak, nonatomic) IBOutlet HMGesturesUnlockView *gesturesUnlockView;
/** 当前创建的手势密码 */
@property (nonatomic, copy) NSString *curentGesturePassword;
/** 当前处理密码类型 (默认是创建密码) */
@property (nonatomic, assign) YWUnlockViewType type;
/** 操作结果 回调 */
@property (nonatomic, copy) CallBackBlock block;

@end

@implementation HMUnlockView



#pragma mark - life cycle
- (void)awakeFromNib{
    [super awakeFromNib];
    self.type = YWUnlockViewCreate;//默认是创建密码
}

#pragma mark - private methods
/** 根据不同的类型处理 */
- (void)handleWithType:(YWUnlockViewType)type password:(NSString *)gesturePassword{
    switch (type) {
        case YWUnlockViewCreate://创建手势密码
            [self createGesturesPassword:gesturePassword];
            break;
        case YWUnlockViewUnlock://解锁手势密码
            [self validateGesturesPassword:gesturePassword];
            break;
    }
}

//创建手势密码
- (void)createGesturesPassword:(NSString *)gesturesPassword {
    if (self.curentGesturePassword.length == 0) {
        if (gesturesPassword.length <4) {
            self.statusLabel.text = @"至少连接四个点，请重新输入";
            [self shakeAnimationForView:self.statusLabel];
            return;
        }
        if (self.resetGesturesPasswordButton.hidden == YES) {
            self.resetGesturesPasswordButton.hidden = NO;
        }
        self.curentGesturePassword = gesturesPassword;
        [self.unlockPreviewView setGesturesPassword:gesturesPassword];
        self.statusLabel.text = @"请再次绘制手势密码";
        return;
    }
    if ([self.curentGesturePassword isEqualToString:gesturesPassword]) {//绘制成功
        //保存手势密码
        [HMUnlockView saveGesturesPassword:gesturesPassword];
        !self.block?:self.block(YES);
        [self hide];
    }else {
        self.statusLabel.text = @"与上一次绘制不一致，请重新绘制";
        [self shakeAnimationForView:self.statusLabel];
    }
}

//验证手势密码
- (void)validateGesturesPassword:(NSString *)gesturesPassword {
    static NSInteger errorCount = 5;
    if ([gesturesPassword isEqualToString:[HMUnlockView getGesturesPassword]]) {
        errorCount = 5;
        !self.block?:self.block(YES);
        [self hide];
    }else {
        if (errorCount - 1 == 0) {//你已经输错五次了！ 退出登陆！
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手势密码已失效" message:@"请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登陆", nil];
            [alertView show];
            errorCount = 5;
            [HMUnlockView deleteGesturesPassword];
            return;
        }
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
        [self shakeAnimationForView:self.statusLabel];
    }
}

//抖动动画
- (void)shakeAnimationForView:(UIView *)view{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - public methods
/** 展示 手势密码视图 */
+ (void)showUnlockViewWithType:(YWUnlockViewType)type callBack:(CallBackBlock)callBack{
    if(type == YWUnlockViewUnlock && ![HMUnlockView getGesturesPassword].length) return;
    HMUnlockView *unlockView = [HMUnlock_BD loadNibNamed:@"HMUnlockView" owner:nil options:nil].lastObject;
    unlockView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    [HMUnlock_KW addSubview:unlockView];
    unlockView.block = [callBack copy];
    unlockView.type = type;
    [UIView animateWithDuration:0.25 animations:^{
        unlockView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    UIImage *image = [UIImage imageNamed:@"gestureBackgroudImg"];
    unlockView.layer.contents = (id) image.CGImage;
}

+ (void)hideUnlockView{
    HMUnlockView *unlockView = [HMUnlock_BD loadNibNamed:@"HMUnlockView" owner:nil options:nil].lastObject;
    if(unlockView != nil){
        [unlockView hide];
    }
}

/** 隐藏视图 */
- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    !self.block?:self.block(NO);
    [self hide];
}


#pragma mark - event response
//点击重新绘制按钮
- (IBAction)resetGesturePassword:(id)sender {
    self.curentGesturePassword = nil;
    self.statusLabel.text = @"请绘制手势密码";
    self.resetGesturesPasswordButton.hidden = YES;
    [self.unlockPreviewView setGesturesPassword:@""];
}

#pragma mark - getters and setters
/** 设置密码的操作类型 */
- (void)setType:(YWUnlockViewType)type{
    _type = type;
    self.unlockPreviewView.hidden = _type != YWUnlockViewCreate;
    self.iconImageView.hidden = _type == YWUnlockViewCreate;
    HMUnlock_WKSELF;
    [self.gesturesUnlockView setDrawRectFinishedBlock:^(NSString *gesturePassword) {
        [weakSelf handleWithType:type password:gesturePassword];
    }];
}

#pragma mark - other methods
/** 是否已经创建过手势密码 */
+ (BOOL)haveGesturePassword{
    return [HMUnlockView getGesturesPassword].length?YES:NO;
}

/** 删除手势密码 */
+ (void)deleteGesturesPassword{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///** 删除手势密码 */
//+ (void)deleteGesturesPassword:(CallBackBlock)callBack{
//    [self deleteGesturesPassword];
//    callBack(@"success");
//}


/** 保存手势密码 */
+ (void)saveGesturesPassword:(NSString *)gesturesPassword {
    [[NSUserDefaults standardUserDefaults] setObject:gesturesPassword forKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 获取手势密码 */
+ (NSString *)getGesturesPassword{
    return [[NSUserDefaults standardUserDefaults] objectForKey:GesturesPassword];
}


@end
