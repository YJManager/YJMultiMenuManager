//
//  YJTableListViewController.h
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/12.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJRootListViewController.h"
#import "YJContainerTableView.h"

typedef void(^ReloadBlock)(NSString *index);

@interface YJTableListViewController : YJRootListViewController

@property (nonatomic, weak)  YJContainerTableView *structureTableView; /**< 结构TableView */
@property (nonatomic, strong) UITableView *tableView; /**< 列表 */

@property (nonatomic, copy) NSString *titleInde; /**< 注释 */
@property (nonatomic, assign) CGFloat redValue; /**< sezhi */
@property (nonatomic, copy) ReloadBlock block; /**< 刷新回调 */

@end
