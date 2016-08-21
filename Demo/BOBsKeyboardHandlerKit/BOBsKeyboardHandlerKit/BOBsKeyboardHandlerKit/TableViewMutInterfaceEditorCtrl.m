//
//  TableViewMutInterfaceEditorCtrl.m
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/19.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "TableViewMutInterfaceEditorCtrl.h"
#import "BOBTableKeyboardUtil.h"

@interface TableViewMutInterfaceEditorCtrl ()
@property (strong, nonatomic) BOBTableKeyboardUtil *tableKeyboardUtil;
@end

@implementation TableViewMutInterfaceEditorCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)configKeyBoardRespond {
    self.tableKeyboardUtil = [[BOBTableKeyboardUtil alloc] init];
    
    __weak TableViewInterfaceEditorCtrl *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_tableKeyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(BOBTableKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.view, nil];
    }];
    
#pragma explain - 自定义键盘弹出处理(如配置，全自动键盘处理则失效)
#pragma explain - use animateWhenKeyboardAppearAutomaticAnimBlock, animateWhenKeyboardAppearBlock must be nil.
    /*
     [_keyboardUtil setAnimateWhenKeyboardAppearBlock:^(int appearPostIndex, CGRect keyboardRect, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
     NSLog(@"\n\n键盘弹出来第 %d 次了~  高度比上一次增加了%0.f  当前高度是:%0.f"  , appearPostIndex, keyboardHeightIncrement, keyboardHeight);
     //do something
     }];
     */
    
#pragma explain - 自定义键盘收起处理(如不配置，则默认启动自动收起处理)
#pragma explain - if not configure this Block, automatically itself.
    /*
     [_keyboardUtil setAnimateWhenKeyboardDisappearBlock:^(CGFloat keyboardHeight) {
     NSLog(@"\n\n键盘在收起来~  上次高度为:+%f", keyboardHeight);
     //do something
     }];
     */
    
#pragma explain - 获取键盘信息
    [_tableKeyboardUtil setPrintKeyboardInfoBlock:^(BOBTableKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}


@end
