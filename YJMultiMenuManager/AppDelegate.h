//
//  AppDelegate.h
//  YJMultiMenuManager
//
//  Created by YJHou on 2017/5/13.
//  Copyright © 2017年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) CGFloat currentOffset; /**< 偏移量 */

+ (AppDelegate *)sharedInstace;


@end

