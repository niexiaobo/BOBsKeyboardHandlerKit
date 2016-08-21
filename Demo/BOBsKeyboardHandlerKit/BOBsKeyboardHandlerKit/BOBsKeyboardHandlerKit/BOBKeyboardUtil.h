//
//  BOBKeyboardUtil.h
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/19.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+BOBs.h"
#import "KeyboardInfo.h"

static CGFloat const DURATION_ANIMATION = 0.5f;

@protocol KeyboardUtilProtocol <NSObject>

#pragma mark - 添加键盘监听对象，可以手动添加多个优先遍历的编辑对象
- (void)adaptiveViewHandleWithController:(UIViewController *)viewController adaptiveView:(UIView *)adaptiveView, ...NS_REQUIRES_NIL_TERMINATION;
@end


@interface BOBKeyboardUtil : NSObject<KeyboardUtilProtocol>
//Block
typedef void (^animateWhenKeyboardAppearBlock)(int appearPostIndex, CGRect keyboardRect, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement);
typedef void (^animateWhenKeyboardDisappearBlock)(CGFloat keyboardHeight);
typedef void (^printKeyboardInfoBlock)(BOBKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo);
typedef void (^animateWhenKeyboardAppearAutomaticAnimBlock)(BOBKeyboardUtil *keyboardUtil);

#pragma mark - 键盘 显示时调用
- (void)setAnimateWhenKeyboardAppearBlock:(animateWhenKeyboardAppearBlock)animateWhenKeyboardAppearBlock;

#pragma mark - 键盘 显示时调用（自动处理时）
- (void)setAnimateWhenKeyboardAppearAutomaticAnimBlock:(animateWhenKeyboardAppearAutomaticAnimBlock)animateWhenKeyboardAppearAutomaticAnimBlock;

#pragma mark - 键盘 隐藏时调用
- (void)setAnimateWhenKeyboardDisappearBlock:(animateWhenKeyboardDisappearBlock)animateWhenKeyboardDisappearBlock;

#pragma mark - 打印键盘信息
- (void)setPrintKeyboardInfoBlock:(printKeyboardInfoBlock)printKeyboardInfoBlock;

@end
