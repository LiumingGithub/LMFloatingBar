//
//  UIWindow+TransparentWindow.m
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/23.
//  Copyright © 2019 ming.liu. All rights reserved.
//

#import "_LMTransparentWindow.h"
#import <objc/runtime.h>

@implementation _LMTransparentWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.windowLevel = UIWindowLevelStatusBar + 100;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([_touchesDelegate window:self shouldReceiveTouchAtPoint:point]) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

- (BOOL)_canAffectStatusBarAppearance
{
    return NO;
}

- (BOOL)_canBecomeKeyWindow
{
    return NO;
}
@end
