//
//  MainViewController.m
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/13.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "MainViewController.h"
#import "YJContainerTableView.h"
#import "YJMultiMenuView.h"
#import "YJRootListViewController.h"
#import "YJMultiMenuViewConfig.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) SubListStatusType listState;
@property (nonatomic, strong) YJContainerTableView *structureTableView; /**< 结构平台 */
@property (nonatomic, strong) UIView *banner; /**< banner */
@property (nonatomic, strong) YJMultiMenuView *multiMenuView; /**< 多视图View */
@property (nonatomic, assign) CGFloat currentOffSet; /**< 当前的偏移量 */

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.listState = SubListStatusNormal;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    

    [self _setUpMainView];
}

- (void)_setUpMainView{
    [self.view addSubview:self.structureTableView];
}

#pragma mark - TableViewdataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:self.multiMenuView];
    
    NSArray *titles = @[@"及诶高低柜都", @"北京国泰大药房"];
    self.multiMenuView.titles = titles;
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGFloat offY = scrollView.contentOffset.y;
    self.currentOffSet = offY;
    NSLog(@"-->%f", offY);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offY = scrollView.contentOffset.y;
//    self.structureTableView.scrollEnabled = !self.multiMenuView.pagesScrollView.isDragging;
    
    if (self.multiMenuView.pagesScrollView.isDragging) {
//        self.structureTableView.contentOffset = CGPointMake(0, self.currentOffSet);
//        return;
    }
    NSLog(@"框架的偏移量-->%f", offY);
    CGFloat navStatusHeight = kYJ_NAV_HEIGHT + kYJ_STATEBAR_HEIGHT; // 64
    CGFloat justHideOffset = isStopOnTop?(kYJ_HeadViewHeight - navStatusHeight):((kYJ_HeadViewHeight + kYJ_TITLESCROLL_HEIGHT) - navStatusHeight);
    if (offY >= justHideOffset) { // 控制title的位置
        self.listState = SubListStatusAtTop;
        scrollView.contentOffset = CGPointMake(0, justHideOffset);
    } else {
        if (offY > -navStatusHeight) { // 64
            
            // 获取子类listView的偏移量
//            CGFloat listViewOffSet = [AppDelegate sharedInstace].currentOffset;
//            if (listViewOffSet != 0.0f && self.listState != SubListStatusNormal) {
////                self.listState = SubListStatusAtTop;
//                scrollView.contentOffset = CGPointMake(0, justHideOffset);
//            }else{
//                self.listState = SubListStatusNormalTop;
//            }
            
            self.listState = SubListStatusNormalTop;

        }else if (offY == -navStatusHeight){
            self.listState = SubListStatusNormal;
            scrollView.contentOffset = CGPointMake(0, -navStatusHeight);
        }else if (offY < -navStatusHeight){
            self.listState = SubListStatusNormalDown;
            scrollView.contentOffset = CGPointMake(0, -navStatusHeight);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy
- (YJContainerTableView *)structureTableView{
    if (!_structureTableView) {
        _structureTableView = [[YJContainerTableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_WIDTH, kScreen_HEIGHT) style:UITableViewStylePlain];
        _structureTableView.dataSource = self;
        _structureTableView.delegate = self;
        _structureTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _structureTableView.tableHeaderView = self.banner;
        _structureTableView.showsVerticalScrollIndicator = NO;
        _structureTableView.showsHorizontalScrollIndicator = NO;
    }
    return _structureTableView;
}

- (UIView *)banner{
    if (!_banner) {
        _banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_WIDTH, kYJ_HeadViewHeight)];
        _banner.backgroundColor = [UIColor redColor];
    }
    return _banner;
}

- (YJMultiMenuView *)multiMenuView{
    if (!_multiMenuView) {
        _multiMenuView = [[YJMultiMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreen_WIDTH, CGRectGetHeight(self.structureTableView.frame))];
        _multiMenuView.managerVc = self;
        _multiMenuView.structureTableView = self.structureTableView;
        _multiMenuView.backgroundColor = [UIColor whiteColor];
    }
    return _multiMenuView;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
