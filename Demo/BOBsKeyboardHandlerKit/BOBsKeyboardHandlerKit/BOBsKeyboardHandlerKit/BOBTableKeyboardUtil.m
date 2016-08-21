//
//  BOBTableKeyboardUtil.m
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/21.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "BOBTableKeyboardUtil.h"


#define MARGIN_KEYBOARD_DEFAULT 10

static UIView *FIRST_RESPONDER;

@interface BOBTableKeyboardUtil()

@property (nonatomic, assign) BOOL keyboardObserveEnabled;
@property (nonatomic, assign) int appearPostIndex;
@property (nonatomic, strong) KeyboardInfo *keyboardInfo;
@property (nonatomic, assign) BOOL haveRegisterObserver;

@property (nonatomic, weak) UIViewController *adaptiveController;
@property (nonatomic, weak) UIView *adaptiveView;
@property (nonatomic, copy) animateWhenKeyboardAppearBlock animateWhenKeyboardAppearBlock;
@property (nonatomic, copy) animateWhenKeyboardAppearAutomaticAnimBlock animateWhenKeyboardAppearAutomaticAnimBlock;
@property (nonatomic, copy) animateWhenKeyboardDisappearBlock animateWhenKeyboardDisappearBlock;
@property (nonatomic, copy) printKeyboardInfoBlock printKeyboardInfoBlock;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) UITableView *firstTable;

@end

@implementation BOBTableKeyboardUtil
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)tableViewArray {
    if (!_tableViewArray) {
        _tableViewArray = [[NSMutableArray alloc]init];
    }
    return _tableViewArray;
}

#pragma mark - 注册键盘 观察
- (void)registerObserver {
    if (_haveRegisterObserver == YES) {
        return;
    }
    
    self.haveRegisterObserver = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 添加键盘监听对象，可以手动添加多个优先遍历的编辑对象
- (void)adaptiveViewHandleWithController:(UIViewController *)viewController adaptiveView:(UIView *)adaptiveView, ...NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *adaptiveViewList = [NSMutableArray array];
    [adaptiveViewList addObject:adaptiveView];
    //NS_REQUIRES_NIL_TERMINATION : attribute((sentinel)) 告知编译器 需要一个结尾的参数,告知编译器参数的列表已经到最后一个不要再继续执行下去了
    
    
    //VA_LIST 是在C语言中解决变参问题的一组宏
    va_list var_list;
    
    // VA_START宏，获取可变参数列表的第一个参数的地址,在这里是获取adaptiveView的内存地址,这时argList的指针 指向adaptiveView
    va_start(var_list, adaptiveView);
    
    // 临时对象
    UIView *view;
    // VA_ARG宏，获取可变参数的当前参数，返回指定类型并将指针指向下一参数
    // 首先 argList的内存地址指向的fristObj将对应储存的值取出,如果不为nil则判断为真,将取出的值房在数组中,
    //并且将指针指向下一个参数,这样每次循环argList所代表的指针偏移量就不断下移直到取出nil
    while ((view = va_arg(var_list, UIView *))) {
        [adaptiveViewList addObject:view];
    }
    va_end(var_list);
    
    [self saveTableViews:viewController];
    
    for (UIView *adaptiveViews in adaptiveViewList) {
        FIRST_RESPONDER = nil;
        
        //获取当前 第一响应者
        UIView *firstResponderView = [self recursionTraverseFindFirstResponderIn:adaptiveViews];
        if (nil != firstResponderView) {
            
            self.adaptiveView = firstResponderView;
            [self fitKeyboardAutomatically:firstResponderView controllerView:viewController.view keyboardRect:_keyboardInfo.frameEnd];
            self.adaptiveController = viewController;
            
            break;
        }
    }
}

#pragma mark - 获取视图内部tableview
- (void)saveTableViews:(UIViewController*)viewController {
    for (UIView *subView in viewController.view.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            [self.tableViewArray addObject:subView];
            self.firstTable = [self.tableViewArray firstObject];
        }
    }
}

//递归视图
- (UIView *)recursionTraverseFindFirstResponderIn:(UIView *)view {
    if ([view isFirstResponder]) {
        FIRST_RESPONDER = view;
    } else {
        //遍历监听对象内部所以子view是否是第一响应者
        for (UIView *subView in view.subviews) {
            if ([subView isFirstResponder]) {
                FIRST_RESPONDER = subView;
                return FIRST_RESPONDER;
            }
            //内部循环，确保不能死循环
            [self recursionTraverseFindFirstResponderIn:subView];
        }
    }
    return FIRST_RESPONDER;
}

#pragma mark - 自动调整编辑对象位置
- (void)fitKeyboardAutomatically:(UIView *)adaptiveView controllerView:(UIView *)controllerView keyboardRect:(CGRect)keyboardRect {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    //1、UIView中的坐标转换 :  http://blog.csdn.net/hopedark/article/details/18215083
    
    // 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    CGRect convertRect = [adaptiveView.superview convertRect:adaptiveView.frame toView:window];
    
#warning  2、如果textView获取光标时，光标位置不在可视范围内的话【被导航遮挡，或者溢出界面】，需要向下滚动到适合位置
    
//    return;
    
    if (CGRectGetMinY(convertRect) < 64) {
        NSLog(@"-被键盘遮住1--->%f<----",self.firstTable.contentOffset.y - (64 - CGRectGetMinY(convertRect)));
         NSLog(@"---->%f<------->%f<----",CGRectGetMaxY(convertRect),CGRectGetMinY(keyboardRect));
        
        [self.firstTable setContentOffset:CGPointMake(0,self.firstTable.contentOffset.y - (64 - CGRectGetMinY(convertRect))) animated:NO];
        
        
    } else if (CGRectGetMaxY(convertRect) > CGRectGetMinY(keyboardRect)){
         NSLog(@"-被键盘遮住2--->%f<----",self.firstTable.contentOffset.y + (CGRectGetMaxY(convertRect) - CGRectGetMinY(keyboardRect)));
        
        NSLog(@"---->%f<------->%f<----",CGRectGetMaxY(convertRect),CGRectGetMinY(keyboardRect));
        //被键盘遮住
        [self.firstTable setContentOffset:CGPointMake(0,self.firstTable.contentOffset.y + (CGRectGetMaxY(convertRect) - CGRectGetMinY(keyboardRect))) animated:NO];
    
       
    }
    
    
    
    
   
}

#pragma mark - 键盘消失时 视图归位
- (void)restoreKeyboardAutomatically {
    [self textViewHandle];
    CGRect tempFrame = self.adaptiveController.view.frame;
    if (self.adaptiveController.navigationController == nil || self.adaptiveController.navigationController.navigationBar.hidden == YES) {
        tempFrame.origin.y = 0.f;
        self.adaptiveController.view.frame = tempFrame;
    } else {
        tempFrame.origin.y = 0;
        self.adaptiveController.view.frame = tempFrame;
    }
}

#pragma mark - 设置textView的ContentOffset归位到顶部
- (void)textViewHandle {
    //还原时 textView可能会出现offset错乱现象
    if ([_adaptiveView isKindOfClass:[UITextView class]]) {
        [(UITextView *)_adaptiveView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - 重写KeyboardInfo set方法，调用animationBlock
- (void)setKeyboardInfo:(KeyboardInfo *)keyboardInfo {
    //home键使应用进入后台也会有某些通知
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        return;
    }
    _keyboardInfo = keyboardInfo;
    if(!keyboardInfo.isSameAction || (keyboardInfo.heightIncrement != 0)) {
        
        [UIView animateWithDuration:keyboardInfo.animationDuration animations:^{
            switch (keyboardInfo.action) {
                case KeyboardActionShow:
                    if(self.animateWhenKeyboardAppearBlock != nil) {
                        self.animateWhenKeyboardAppearBlock(++self.appearPostIndex, keyboardInfo.frameEnd, keyboardInfo.frameEnd.size.height, keyboardInfo.heightIncrement);
                    } else if (self.animateWhenKeyboardAppearAutomaticAnimBlock != nil) {
                        self.animateWhenKeyboardAppearAutomaticAnimBlock(self);
                    }
                    break;
                case KeyboardActionHide:
                    if(self.animateWhenKeyboardDisappearBlock != nil) {
                        self.animateWhenKeyboardDisappearBlock(keyboardInfo.frameEnd.size.height);
                        self.appearPostIndex = 0;
                    } else {
                        //auto restore
                        [self restoreKeyboardAutomatically];
                    }
                    break;
                default:
                    break;
            }
            [CATransaction commit];
        }completion:^(BOOL finished) {
            if(self.printKeyboardInfoBlock != nil && self.keyboardInfo != nil) {
                self.printKeyboardInfoBlock(self, keyboardInfo);
            }
        }];
    }
}

- (void)triggerAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.keyboardInfo = _keyboardInfo;
    });
}

#pragma mark - 重写Block set方法，懒加载方式注册观察者
/**
 * @brief handle the covering event youself when keyboard Appear, Animation automatically.
 *
 * use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
 */
- (void)setAnimateWhenKeyboardAppearBlock:(animateWhenKeyboardAppearBlock)animateWhenKeyboardAppearBlock {
    _animateWhenKeyboardAppearBlock = animateWhenKeyboardAppearBlock;
    [self registerObserver];
}

/**
 * @brief handle the covering automatically, you must invoke the method adaptiveViewHandleWithController:adaptiveView: by the param keyboardUtil.
 *
 * use animateWhenKeyboardAppearAutomaticAnimBlock, animateWhenKeyboardAppearBlock must be nil.
 */
- (void)setAnimateWhenKeyboardAppearAutomaticAnimBlock:(animateWhenKeyboardAppearAutomaticAnimBlock)animateWhenKeyboardAppearAutomaticAnimBlock {
    _animateWhenKeyboardAppearAutomaticAnimBlock = animateWhenKeyboardAppearAutomaticAnimBlock;
    [self registerObserver];
}

/**
 * @brief restore the UI youself when keyboard disappear.
 *
 * if not configure this Block, automatically itself.
 */
- (void)setAnimateWhenKeyboardDisappearBlock:(animateWhenKeyboardDisappearBlock)animateWhenKeyboardDisappearBlock {
    _animateWhenKeyboardDisappearBlock = animateWhenKeyboardDisappearBlock;
    [self registerObserver];
}

- (void)setPrintKeyboardInfoBlock:(printKeyboardInfoBlock)printKeyboardInfoBlock {
    _printKeyboardInfoBlock = printKeyboardInfoBlock;
    [self registerObserver];
}

#pragma mark 响应selector
- (void)keyboardWillShow:(NSNotification *)notification {
    if(self.keyboardInfo.action != KeyboardActionShow){
        self.keyboardInfo.action = KeyboardActionShow;
        
        NSDictionary* info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
        NSLog(@"hight_hitht:%f",kbSize.height);
        self.firstTable.height = self.adaptiveController.view.height - 64 - kbSize.height;
    }
    
    [self handleKeyboard:notification keyboardAction:KeyboardActionShow];
}

- (void)keyboardDidShow:(NSNotification *)notification {
//    self.keyboardInfo.action = KeyboardActionDefault;
    
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if(self.keyboardInfo.action == KeyboardActionShow){
        [self handleKeyboard:notification keyboardAction:KeyboardActionShow];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if(self.keyboardInfo.action != KeyboardActionHide){
        self.keyboardInfo.action = KeyboardActionHide;
        
        NSDictionary* info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
        NSLog(@"hight_hitht:%f",kbSize.height);
        self.firstTable.height = self.adaptiveController.view.height - 64;
    }

    [self handleKeyboard:notification keyboardAction:KeyboardActionHide];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    //置空
    self.keyboardInfo = nil;
}

#pragma mark 处理键盘事件
- (void)handleKeyboard:(NSNotification *)notification keyboardAction:(KeyboardAction)keyboardAction {
    //进入后台触发某些通知,不响应
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        return;
    }
    //解析通知
    NSDictionary *infoDict = [notification userInfo];
    CGRect frameBegin = [[infoDict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [[infoDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat previousHeight;
    if(self.keyboardInfo.frameEnd.size.height > 0) {
        previousHeight = self.keyboardInfo.frameEnd.size.height;
    }else {
        previousHeight = 0;
    }
    
    CGFloat heightIncrement = frameEnd.size.height - previousHeight;
    
    //是否相同操作，这里屏蔽，默认NO，这样变动光标也会重新计算一遍
    BOOL isSameAction = NO;
//    if(self.keyboardInfo.action == keyboardAction) {
//        isSameAction = YES;
//    }else {
//        isSameAction = NO;
//    }
    
    KeyboardInfo *info = [[KeyboardInfo alloc] init];
    [info fillKeyboardInfoWithDuration:DURATION_ANIMATION frameBegin:frameBegin frameEnd:frameEnd heightIncrement:heightIncrement action:keyboardAction isSameAction:isSameAction];
    
    self.keyboardInfo = info;
}

- (void)fillKeyboardInfoWithKeyboardInfo:(KeyboardInfo *)keyboardInfo duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd heightIncrement:(CGFloat)heightIncrement action:(KeyboardAction)action isSameAction:(BOOL)isSameAction {
    keyboardInfo.animationDuration = duration;
    keyboardInfo.frameBegin = frameBegin;
    keyboardInfo.frameEnd = frameEnd;
    keyboardInfo.heightIncrement = heightIncrement;
    keyboardInfo.action = action;
    keyboardInfo.isSameAction = isSameAction;
}

@end