//
//  YJMultiMenuView.h
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/12.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJContainerTableView.h"

@interface YJMultiMenuView : UIView

@property (nonatomic, weak)  YJContainerTableView *structureTableView; /**< 结构TableView */
@property (nonatomic, weak) UIViewController *managerVc;
@property (nonatomic, strong) NSArray *titles; /**< 标题们 */
@property (nonatomic, strong) UIScrollView *pagesScrollView; /**< 页面Scrol */

@end
