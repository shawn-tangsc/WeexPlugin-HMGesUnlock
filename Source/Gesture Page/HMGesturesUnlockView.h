//
//  Created by dyw on 2017/2/25.
//  Copyright © 2017年 dyw. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HMGesturesUnlockView : UIView

@property (nonatomic, copy) void(^drawRectFinishedBlock)(NSString *gesturePassword);

@end
