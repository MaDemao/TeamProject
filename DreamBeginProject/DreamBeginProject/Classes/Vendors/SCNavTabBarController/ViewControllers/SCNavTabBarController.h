//
//  SCNavTabBarController.h
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCNavTabBar;

@interface SCNavTabBarController : UIViewController

@property (nonatomic, assign)   BOOL        canPopAllItemMenu;          // Default value: YES 点击下拉选择框
@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO  切换显示页面的跳转动画
@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO  设置页面边缘是否可以滑动

@property (nonatomic, strong)   NSArray     *subViewControllers;        // An array of children view controllers 存放显示的子控制器的

@property (nonatomic, strong)   UIColor     *navTabBarColor;            // Could not set [UIColor clear], if you set, NavTabbar will show initialize color 整个条的颜色

@property (nonatomic, strong)   UIColor     *navTabBarLineColor;
@property (nonatomic, strong)   UIImage     *navTabBarArrowImage;

/**
 *  Initialize Methods
 *
 *  @param show - can pop all item menu
 *
 *  @return Instance
 */
//下拉框方法
- (id)initWithCanPopAllItemMenu:(BOOL)can;

/**
 *  Initialize SCNavTabBarViewController Instance And Show Children View Controllers
 *
 *  @param subViewControllers - set an array of children view controllers
 *
 *  @return Instance
 */
//初始化方法 直接加载子控制器数组
- (id)initWithSubViewControllers:(NSArray *)subViewControllers;

/**
 *  Initialize SCNavTabBarViewController Instance And Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 *
 *  @return Instance
 */

//初始化 设置设置父控制器
- (id)initWithParentViewController:(UIViewController *)viewController;

/**
 *  Initialize SCNavTabBarViewController Instance, Show On The Parent View Controller And Show On The Parent View Controller
 *
 *  @param subControllers - set an array of children view controllers
 *  @param viewController - set parent view controller
 *  @param can            - can pop all item menu
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController canPopAllItemMenu:(BOOL)can;

/**
 *  Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 */

//添加到父控制器
- (void)addParentController:(UIViewController *)viewController;

@end
