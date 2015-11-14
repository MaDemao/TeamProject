//
//  BJ_tabBarViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_tabBarViewController.h"
#import "SCNavTabBarController.h"
#import "BJ_FirstTableViewController.h"
#import "BJ_projectTableViewController.h"
#import "BJ_allTableViewController.h"

@interface BJ_tabBarViewController ()

@end

@implementation BJ_tabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";

    BJ_FirstTableViewController *oneController = [[BJ_FirstTableViewController alloc]initWithURLString:kBaseUrlWithRecommended];
    oneController.title = @"推荐";
    BJ_projectTableViewController *twoController = [[BJ_projectTableViewController alloc]initWithUrl:kBaseUrlWithProject];
    twoController.title = @"专题";
    BJ_allTableViewController *threeController = [[BJ_allTableViewController alloc]initWithUrl:kBaseUrlWithTure];
    threeController.title = @"真相";
     BJ_allTableViewController *fourController = [[ BJ_allTableViewController alloc]initWithUrl:kBaseUrlWithRead];
    fourController.title = @"一图读懂";
     BJ_allTableViewController *fiveController = [[BJ_allTableViewController alloc]initWithUrl:kBaseUrlWithTumor];
    fiveController.title = @"肿瘤";
    BJ_allTableViewController *sixController = [[BJ_allTableViewController alloc]initWithUrl:kBaseUrlWithSlowDisease];
    sixController.title = @"慢病";
    BJ_allTableViewController *sevenController = [[BJ_allTableViewController alloc]initWithUrl:kBaseUrlWithNutrition];
    sevenController.title = @"营养";
    BJ_allTableViewController *eightController = [[BJ_allTableViewController alloc]initWithUrl:kBaseUrlWithMaternalAndInfant];
    eightController.title = @"母婴";
 
    SCNavTabBarController *navTab = [[SCNavTabBarController alloc]init];
       
    //添加控制器列表
    navTab.subViewControllers = @[oneController,twoController,threeController,fourController,fiveController,sixController,sevenController,eightController];
    

    navTab.canPopAllItemMenu = NO;
    navTab.scrollAnimation = YES;
    navTab.mainViewBounces = NO;
    navTab.navTabBarColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [navTab addParentController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
