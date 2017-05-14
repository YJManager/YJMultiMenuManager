//
//  YJRootListViewController.h
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/12.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const HeadViewHeight = 200;
static CGFloat const BS_NAV_H = 44;
static CGFloat const BS_STATEBAR_H = 20;
static CGFloat const BS_TABBAR_H = 49;

/** 子list的状态 */
typedef NS_ENUM(NSInteger, SubListStatusType) {
    SubListStatusAtTop = 0,         // 在顶部悬停
    SubListStatusNormal = 1,        // 正常初始状态
    SubListStatusNormalTop = 2,     // 上滚
    SubListStatusNormalDown = 3     // 下滚
};


@interface YJRootListViewController : UIViewController

@property (nonatomic, weak) UIViewController *managerVc;

@property (strong, nonatomic) UIScrollView *scrollView;


- (void)listViewDidAppear;

@end
