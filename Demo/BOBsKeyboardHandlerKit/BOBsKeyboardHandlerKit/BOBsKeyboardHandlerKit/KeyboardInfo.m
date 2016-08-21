//
//  KeyboardInfo.m
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/19.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "KeyboardInfo.h"

@interface KeyboardInfo()

@end

@implementation KeyboardInfo
- (void)fillKeyboardInfoWithDuration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd heightIncrement:(CGFloat)heightIncrement action:(KeyboardAction)action isSameAction:(BOOL)isSameAction {
    self.animationDuration = duration;
    self.frameBegin = frameBegin;
    self.frameEnd = frameEnd;
    self.heightIncrement = heightIncrement;
    self.action = action;
    self.isSameAction = isSameAction;
}
@end
