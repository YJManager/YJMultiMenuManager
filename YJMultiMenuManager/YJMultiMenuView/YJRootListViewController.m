//
//  YJRootListViewController.m
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/12.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJRootListViewController.h"
#import "AppDelegate.h"

@interface YJRootListViewController (){
    CGFloat _preIsCanScrollOffY;
}
@property (nonatomic, assign) BOOL isCanScroll;

@end

@implementation YJRootListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isCanScroll = NO;
}

- (void)listViewDidAppear{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    NSLog(@"-->%f----H=%f", offsetY, contentHeight);
    
    if (_isCanScroll) { // 可以滑动子list 记录偏移量
        _preIsCanScrollOffY = MAX(offsetY, 0);
    }else{ // 不可滑动 保持之前的偏移量
        _isCanScroll = YES;
        [scrollView setContentOffset:CGPointMake(0, _preIsCanScrollOffY)];
    }
    
    [AppDelegate sharedInstace].currentOffset = _preIsCanScrollOffY;
    _scrollView = scrollView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:@"listState"]) {
        SubListStatusType type = [[change objectForKey:@"new"] integerValue];
        
        if (type == SubListStatusNormalTop) {
            _isCanScroll = NO;
        } else {
            _isCanScroll = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
