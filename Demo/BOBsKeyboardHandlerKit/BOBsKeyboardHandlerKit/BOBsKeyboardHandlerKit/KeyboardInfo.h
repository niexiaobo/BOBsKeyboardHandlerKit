//
//  KeyboardInfo.h
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/19.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 键盘状态
typedef enum {
    KeyboardActionDefault,
    KeyboardActionShow,//显示
    KeyboardActionHide//隐藏
}KeyboardAction;

@interface KeyboardInfo : NSObject
@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) CGRect frameBegin;
@property (assign, nonatomic) CGRect frameEnd;
@property (assign, nonatomic) CGFloat heightIncrement;
@property (assign, nonatomic) KeyboardAction action;
@property (assign, nonatomic) BOOL isSameAction;

- (void)fillKeyboardInfoWithDuration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd heightIncrement:(CGFloat)heightIncrement action:(KeyboardAction)action isSameAction:(BOOL)isSameAction;
@end
