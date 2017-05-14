//
//  YJContainerTableView.m
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/12.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import "YJContainerTableView.h"

@implementation YJContainerTableView

// 同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
