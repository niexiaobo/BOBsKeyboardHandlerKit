//
//  KeyboardToolView.h
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/19.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+BOBs.h"

@protocol KeyboardToolViewDelegate <NSObject>
- (void)toolButtonClick:(UIButton*)btn;
@end

@interface KeyboardToolView : UIView
@property(nonatomic, weak) id<KeyboardToolViewDelegate> Delegate;

+ (KeyboardToolView *)initWithToolViewFrame:(CGRect)frame;
@end
