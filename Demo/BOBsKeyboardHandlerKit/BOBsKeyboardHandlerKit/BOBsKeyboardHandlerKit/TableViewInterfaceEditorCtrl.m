//
//  TableViewInterfaceEditorCtrl.m
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/16.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "TableViewInterfaceEditorCtrl.h"
#import "ZYKeyboardUtil.h"

@interface TableViewInterfaceEditorCtrl ()<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@end

@implementation TableViewInterfaceEditorCtrl
- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    
    __weak TableViewInterfaceEditorCtrl *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
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
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

#pragma mark delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self configKeyBoardRespond];
//    [self registerObserver];
    [self.tableView reloadData];
    
    
}

#pragma mark - 数组懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSArray *titleArray = @[@"普通的界面单层编辑", @"tableView多层编辑", @"综合编辑",@"普通的界面单层编辑", @"tableView多层编辑", @"综合编辑" ];
        _dataArray = [[NSMutableArray alloc] initWithArray:titleArray];
        
    }
    return _dataArray;
}

#pragma mark - table 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 15; //第一行cell间隔
    }else{
        return 162;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
        
        static NSString *CellIdentifier = @"UITableViewCellTitle";
        UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:CellIdentifier];
            cell.clipsToBounds = YES;
            //选中cell背景色无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        NSString *titleStr = self.dataArray[indexPath.row - 1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = titleStr;
        UITextField *testView2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
        testView2.delegate = self;
        testView2.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:testView2];
        
        UITextView *testView = [[UITextView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 100)];
        testView.delegate = self;
        [cell.contentView addSubview:testView];

        cell.backgroundColor = [UIColor redColor];
        return cell;
        
    } else {
        static NSString *CellIdentifier = @"UITableViewCell";
        UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.clipsToBounds = YES;
        }
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        return cell;
    }
}


#pragma mark - lazy注册观察者
- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark 响应selector
- (void)keyboardWillShow:(NSNotification *)notification {
    
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            
            NSLog(@"---class->%@<----",[subView class]);
            self.view.y -= 300;
            
            if (fabs(self.view.y)  >  kbSize.height) {
                NSLog(@"---溢出----");
            } else {
                NSLog(@"---没有 溢出----");
            }
        }
        
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.view.y = 0;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.view endEditing:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
