//
//  YJTableListViewController.m
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/12.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJTableListViewController.h"
#import "YJMultiMenuViewConfig.h"

@interface YJTableListViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation YJTableListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableViewdataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arc4random() % 10 + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.5 green:self.redValue blue:self.redValue alpha:1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %ld", self.titleInde, indexPath.row];
    
    return cell;
}

- (void)listViewDidAppear{
    [super listViewDidAppear];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 10) {
        if (self.block) {
            self.block(self.titleInde);
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableHeight = isStopOnTop?36.0f:0.0f;
        _tableView  =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_WIDTH, self.view.bounds.size.height - (kYJ_NAV_HEIGHT + kYJ_STATEBAR_HEIGHT + tableHeight)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setTableFooterView:[UIView new]];
    }
    return _tableView;
}

@end
