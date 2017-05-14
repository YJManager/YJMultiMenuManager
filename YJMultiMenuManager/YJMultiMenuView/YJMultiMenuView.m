//
//  YJMultiMenuView.m
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/12.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJMultiMenuView.h"
#import "YJRootListViewController.h"
#import "YJTableListViewController.h"

//控制 被选择的选项 缩放显示
static const CGFloat targetXScale = 1.2;
static const CGFloat normalXScale = 1.0;
static const CGFloat targetYScale = 1.1;
static const CGFloat normalYScale = 1.0;


#define menuW self.bounds.size.width
#define menuH self.bounds.size.height

#define titleH  36.0f
#define pageH menuH - titleH

@interface YJMultiMenuView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titlesScrollView; /**< title */

@property (nonatomic, strong) NSMutableArray *allTitleBtns; /**< 所有的按钮 */
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, strong) NSArray *pageControllers; /**< 子页们 */

@end

@implementation YJMultiMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self _setUpMainView];
    }
    return self;
}

- (void)_setUpMainView{
    
    [self addSubview:self.titlesScrollView];
    [self addSubview:self.pagesScrollView];

}

#pragma mark - 设置标题
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    // 1.移除之前的
    if (self.allTitleBtns.count > 0) {
        [self.allTitleBtns removeAllObjects];
        for (UIButton *btn in self.titlesScrollView.subviews) {
            [btn removeFromSuperview];
        }
    }
    
    // 配置数据
    UIFont *titleFont = [UIFont systemFontOfSize:14.0];
    CGFloat titleY = 0.0f;
    CGFloat titleSpace = 20.0f;
    CGFloat titleWidths = 0.0f;
    CGFloat titleHeight = CGRectGetHeight(self.titlesScrollView.frame);
    NSMutableArray *titleWidthSources = [NSMutableArray array];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString  *title = [titles objectAtIndex:i];
        CGFloat eachTitleW = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}].width + titleSpace;
        titleWidths += eachTitleW;
        if (i == titles.count - 1) {
            titleWidths += titleSpace;
        }
    }
    
    if (titleWidths < menuW) { // 平分且保证容得下
        CGFloat average = (CGFloat)(menuW - (titles.count + 1) * titleSpace) / titles.count;
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString  *title = [titles objectAtIndex:i];
            CGFloat eachTitleW = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}].width;
            
            CGFloat finlewidth = MAX(eachTitleW, average);
            [titleWidthSources addObject:[NSNumber numberWithDouble:finlewidth]];
        }
    }else{
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString  *title = [titles objectAtIndex:i];
            CGFloat eachTitleW = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}].width;
            [titleWidthSources addObject:[NSNumber numberWithDouble:eachTitleW]];
        }
    }
    
    // 摆控件
    
    CGFloat titleX = titleSpace;
    CGSize titleContentSize = CGSizeMake(0, titleHeight);
    for (int i = 0;i < titles.count; i++) {
        
        NSString *titleStr = [titles objectAtIndex:i];
        CGFloat titleShowW = ((NSNumber *)[titleWidthSources objectAtIndex:i]).doubleValue;
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(titleX, titleY, titleShowW, titleHeight);
        [titleBtn setTitle:titleStr forState:UIControlStateNormal];
        titleBtn.titleLabel.font = titleFont;
        [titleBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
        titleBtn.backgroundColor = [UIColor whiteColor];
        [titleBtn addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesScrollView addSubview:titleBtn];
        [self.allTitleBtns addObject:titleBtn];
        
        titleX += (titleShowW + titleSpace);
        titleContentSize.width = CGRectGetMaxX(titleBtn.frame) + titleSpace;
    }
    
    self.titlesScrollView.contentSize = titleContentSize;
    
    // pages
    NSMutableArray *vcs = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        YJTableListViewController *tableList1 = [[YJTableListViewController alloc] init];
//        tableList1.view.backgroundColor = [UIColor redColor];
        tableList1.structureTableView = self.structureTableView;
        tableList1.titleInde = [titles objectAtIndex:i];
        tableList1.redValue = (arc4random() % 10) / 10.0f;
        __weak typeof(tableList1) weakSelf = tableList1;
        tableList1.block = ^(NSString *index) {
            NSLog(@"-->%@--- %@", index, weakSelf.tableView);
            [weakSelf.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        };
        [vcs addObject:tableList1];
    }
    self.pageControllers = (NSArray *)vcs;
}

- (void)setPageControllers:(NSArray *)pageControllers{
    _pageControllers = pageControllers;
    
    CGFloat pageW = self.bounds.size.width, pageHeight = CGRectGetHeight(_pagesScrollView.frame);
    CGFloat pageX = 0, pageY = 0;
    
    CGSize pageContentSize = CGSizeMake(pageW, pageHeight);
    for (int i = 0; i < pageControllers.count; i++) {
        
        YJRootListViewController *rootVc = [pageControllers objectAtIndex:i];
        rootVc.view.frame = CGRectMake(pageX, pageY, pageW, pageHeight);
        // 添加每一页的视图
        [_pagesScrollView addSubview:rootVc.view];
        
        [self.managerVc addChildViewController:rootVc];
        [rootVc didMoveToParentViewController:self.managerVc];
        rootVc.managerVc = self.managerVc;
        [self.managerVc addObserver:rootVc forKeyPath:@"listState" options:NSKeyValueObservingOptionNew context:nil];
        
        pageX += pageW;
        pageContentSize.width = CGRectGetMaxX(rootVc.view.frame);
    }
    
    _pagesScrollView.contentSize = pageContentSize;
}


- (void)titleButtonClicked:(UIButton *)btn{
    
    [self changeTitleButtonState:btn];
    
    CGFloat pageW = self.bounds.size.width;
    NSInteger titleIndex = [self.allTitleBtns indexOfObject:_selectedBtn];
    [self.pagesScrollView setContentOffset:CGPointMake(titleIndex*pageW, 0) animated:YES];
    
    [self calAndMoveSelectedBtnToMidWith:titleIndex];
    
    [self someVcListViewDidAppear:titleIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offX = scrollView.contentOffset.x;
    
    if (scrollView == self.titlesScrollView) {
        
    } else {
        //1.选中与页面相对应的标题 并改变其状态
        CGFloat pageW = self.bounds.size.width;
        NSInteger pageIndex = roundf(offX / pageW);
        [self changeTitleButtonState:[self.allTitleBtns objectAtIndex:pageIndex]];
        
        //2.
        [self calAndMoveSelectedBtnToMidWith:pageIndex];
        
        //3.
        [self someVcListViewDidAppear:pageIndex];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.structureTableView.scrollEnabled = NO;
}

/** 滑动减速停止 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    self.structureTableView.scrollEnabled = YES;
    
//    CGFloat offX = scrollView.contentOffset.x;
//    
//    if (scrollView == self.titlesScrollView) {
//        
//    } else {
//        
//        //1.选中与页面相对应的标题 并改变其状态
//        CGFloat pageW = self.bounds.size.width;
//        NSInteger pageIndex = roundf(offX / pageW);
//        [self changeTitleButtonState:[self.allTitleBtns objectAtIndex:pageIndex]];
//        
//        //2.
//        [self calAndMoveSelectedBtnToMidWith:pageIndex];
//        
//        //3.
//        [self someVcListViewDidAppear:pageIndex];
//    }
    
}

- (void)changeTitleButtonState:(UIButton *)sender {
    
    if (!sender.selected) {
        _selectedBtn.selected = NO;
        _selectedBtn.transform = CGAffineTransformMakeScale(normalXScale, normalYScale);;
        _selectedBtn = sender;
        sender.selected = YES;
        sender.transform = CGAffineTransformMakeScale(targetXScale, targetYScale);
    }
}
/** 让标题是否居中计算 */
- (void)calAndMoveSelectedBtnToMidWith:(NSInteger)pageIndex {
    CGFloat titleScrollW = CGRectGetWidth(_titlesScrollView.frame);
    CGFloat midDisplayOffX = _selectedBtn.center.x-titleScrollW*0.5;
    CGFloat contentViewW = _titlesScrollView.contentSize.width;
    
    if (midDisplayOffX > 0 && midDisplayOffX < contentViewW-titleScrollW) {
        [_titlesScrollView setContentOffset:CGPointMake(midDisplayOffX, 0) animated:YES];
    } else {
        if (midDisplayOffX >= contentViewW-titleScrollW) {
            [_titlesScrollView setContentOffset:CGPointMake(contentViewW-titleScrollW, 0) animated:YES];
        } else if (midDisplayOffX <= 0) {
            [_titlesScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

/** 选择某一个页面需要展示的时候 调用该页面对应控制器的加载方法 */
- (void)someVcListViewDidAppear:(NSInteger)pageIndex {
    
    YJTableListViewController *listVc = self.pageControllers[pageIndex];
    [listVc listViewDidAppear];
}

#pragma mark - Lazy
- (UIScrollView *)titlesScrollView{
    if (!_titlesScrollView) {
        _titlesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, menuW, titleH)];
        _titlesScrollView.delegate = self;
        _titlesScrollView.showsVerticalScrollIndicator = NO;
        _titlesScrollView.showsHorizontalScrollIndicator = NO;
        _titlesScrollView.backgroundColor = [UIColor cyanColor];
    }
    return _titlesScrollView;
}

- (UIScrollView *)pagesScrollView{
    if (!_pagesScrollView) {
        _pagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titlesScrollView.frame), menuW, pageH)];
        _pagesScrollView.delegate = self;
        _pagesScrollView.pagingEnabled = YES;
        _pagesScrollView.showsHorizontalScrollIndicator = NO;
        _pagesScrollView.showsVerticalScrollIndicator = NO;
//        _pagesScrollView.backgroundColor = [UIColor blueColor];
    }
    return _pagesScrollView;
}

- (NSMutableArray *)allTitleBtns{
    if (!_allTitleBtns) {
        _allTitleBtns = [NSMutableArray array];
    }
    return _allTitleBtns;
}

@end
