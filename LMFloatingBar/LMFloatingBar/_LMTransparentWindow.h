//
//  UIWindow+TransparentWindow.h
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/23.
//  Copyright © 2019 ming.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol _LMTransparentWindowTouchesHandling <NSObject>

- (BOOL)window:(nullable UIWindow *)window shouldReceiveTouchAtPoint:(CGPoint)point;

@end
@interface _LMTransparentWindow: UIWindow

@property (nonatomic, weak, nullable) id<_LMTransparentWindowTouchesHandling> touchesDelegate;

@end

NS_ASSUME_NONNULL_END
