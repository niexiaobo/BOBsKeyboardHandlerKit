//
//  ViewController.m
//  BOBsKeyboardHandlerKit
//
//  Created by beyondsoft-聂小波 on 16/8/16.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "ViewController.h"
#import "SingleInterfaceEditorCtrl.h"
#import "TableViewInterfaceEditorCtrl.h"

@interface ViewController ()
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能列表";
    [self.tableView reloadData];
    

}

#pragma mark - 数组懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSArray *titleArray = @[@"普通的界面单层编辑", @"tableView多层编辑", @"综合编辑" ];
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
        return 62;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        SingleInterfaceEditorCtrl * ctrl = [[SingleInterfaceEditorCtrl alloc]init];
        ctrl.title = self.dataArray[indexPath.row - 1];
        [self.navigationController pushViewController:ctrl animated:YES];
    } else if (indexPath.row == 2) {
        TableViewInterfaceEditorCtrl * ctrl = [[TableViewInterfaceEditorCtrl alloc]init];
        ctrl.title = self.dataArray[indexPath.row - 1];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    
    
    
    
}


@end
