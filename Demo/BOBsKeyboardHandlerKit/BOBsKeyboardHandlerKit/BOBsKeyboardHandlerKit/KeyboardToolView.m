//
//  KeyboardToolView.m
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/19.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "KeyboardToolView.h"

@implementation KeyboardToolView
#pragma mark - 键盘 tabbar
+ (KeyboardToolView *)initWithToolViewFrame:(CGRect)frame {
//    CGRectMake(0, 0, TextScreenwidth, 50)
    KeyboardToolView *toolView  = [[KeyboardToolView alloc]initWithFrame:frame];
    toolView.backgroundColor = [UIColor whiteColor];
//    self.inputAccessoryView  = toolView;
    
    UIButton *losebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    losebtn.frame = CGRectMake(20, 0, 50, 50);
    [losebtn addTarget:toolView action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [losebtn setTitleColor:[UIColor colorWithRed:(float)201/255.0 green:(float)52/255.0 blue:(float)21/255.0 alpha:1] forState:UIControlStateNormal];
    [losebtn setTitle:@"完成" forState:UIControlStateNormal];
    losebtn.tag = 0;
    [toolView addSubview:losebtn];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setTitle:@"取消" forState:UIControlStateNormal];
    imageBtn.frame = CGRectMake(TextScreenwidth-58, 0, 58 , 44);
    [imageBtn setTitleColor:[UIColor colorWithRed:(float)201/255.0 green:(float)52/255.0 blue:(float)21/255.0 alpha:1] forState:UIControlStateNormal];
    [imageBtn addTarget:toolView action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.tag = 1;
    [toolView addSubview:imageBtn];
    
    return toolView;
}

#pragma mark - 完成
- (void)BtnClick:(UIButton*)btn {
    if ([self.Delegate respondsToSelector:@selector(toolButtonClick:)]) {
        [self.Delegate toolButtonClick:btn];
    }
}

@end
