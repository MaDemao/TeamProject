//
//  MDMUserCollectVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/17.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserCollectVC.h"
#import <MJRefresh.h>
#import "MDMUserHelper.h"
#import "MDMCollectCell.h"
#import "BJ_detailsPageViewController.h"


@interface MDMUserCollectVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, assign) NSInteger currentPageOfNews;
@property (nonatomic, assign) NSInteger currentPageOfInfo;
@property (nonatomic, assign) NSInteger totilPageOfNews;
@property (nonatomic, assign) NSInteger totilPageOfInfo;

@end

@implementation MDMUserCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    self.navigationController.navigationBar.translucent = NO;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    
    [self.newsTableView registerNib:[UINib nibWithNibName:@"MDMCollectCell" bundle:nil] forCellReuseIdentifier:@"MDMCollectCell"];
    [self.infoTableView registerNib:[UINib nibWithNibName:@"MDMCollectCell" bundle:nil] forCellReuseIdentifier:@"MDMCollectCell"];
    
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.newsArray removeAllObjects];
        
        AVQuery *queryC1 = [MDMCollect query];
        [queryC1 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
        AVQuery *queryC2 = [MDMCollect query];
        [queryC2 whereKey:@"type" equalTo:@"BJ"];
        AVQuery *queryC = [AVQuery andQueryWithSubqueries:@[queryC1, queryC2]];
        [queryC countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
            self.currentPageOfNews = 1;
            self.totilPageOfNews = number / 7;
        }];
        
        AVQuery *query1 = [MDMCollect query];
        [query1 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
        AVQuery *query2 = [MDMCollect query];
        [query2 whereKey:@"type" equalTo:@"BJ"];
        AVQuery *query3 = [MDMCollect query];
        [query3 orderByDescending:@"createdAt"];
        AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2, query3]];
        query.limit = 7;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (objects.count > 0) {
                    [self.newsArray addObjectsFromArray:objects];
                }
                [self.newsTableView.mj_header endRefreshing];
                [self.newsTableView reloadData];
            });
        }];
    }];
    
    self.infoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.infoArray removeAllObjects];
        
        AVQuery *queryC1 = [MDMCollect query];
        [queryC1 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
        AVQuery *queryC2 = [MDMCollect query];
        [queryC2 whereKey:@"type" equalTo:@"LAN"];
        AVQuery *queryC = [AVQuery andQueryWithSubqueries:@[queryC1, queryC2]];
        [queryC countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
            self.currentPageOfInfo = 1;
            self.totilPageOfInfo = number / 7;
        }];
        
        AVQuery *query1 = [MDMCollect query];
        [query1 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
        AVQuery *query2 = [MDMCollect query];
        [query2 whereKey:@"type" equalTo:@"LAN"];
        AVQuery *query3 = [MDMCollect query];
        [query3 orderByDescending:@"createdAt"];
        
        AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2, query3]];
        query.limit = 7;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (objects.count > 0) {
                    [self.infoArray addObjectsFromArray:objects];
                }
                [self.infoTableView.mj_header endRefreshing];
                [self.infoTableView reloadData];
            });
        }];
    }];
    
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentPageOfNews <= self.totilPageOfNews) {
            AVQuery *query1 = [MDMCollect query];
            [query1 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
            AVQuery *query2 = [MDMCollect query];
            [query2 whereKey:@"type" equalTo:@"BJ"];
            AVQuery *query3 = [MDMCollect query];
            [query3 orderByDescending:@"createdAt"];
            AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2, query3]];
            query.limit = 7;
            query.skip = 7 * self.currentPageOfNews;
            self.currentPageOfNews++;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (objects.count > 0) {
                        [self.newsArray addObjectsFromArray:objects];
                    }
                    [self.newsTableView.mj_header endRefreshing];
                    [self.newsTableView reloadData];
                });
            }];
        }else{
            [self.newsTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    self.infoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentPageOfInfo <= self.totilPageOfInfo) {
            AVQuery *query1 = [MDMCollect query];
            [query1 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
            AVQuery *query2 = [MDMCollect query];
            [query2 whereKey:@"type" equalTo:@"LAN"];
            AVQuery *query3 = [MDMCollect query];
            [query3 orderByDescending:@"createdAt"];
            AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2, query3]];
            query.limit = 7;
            query.skip = 7 * self.currentPageOfInfo;
            self.currentPageOfInfo++;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (objects.count > 0) {
                        [self.infoArray addObjectsFromArray:objects];
                    }
                    [self.infoTableView.mj_header endRefreshing];
                    [self.infoTableView reloadData];
                });
            }];
        }else{
            [self.infoTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self.newsTableView.mj_header beginRefreshing];
    [self.infoTableView.mj_header beginRefreshing];
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    if (self.scrollView.contentOffset.x == 0) {
        if (self.newsTableView.editing == YES) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
        }else{
            self.navigationItem.rightBarButtonItem.title = @"完成";
        }
        self.newsTableView.editing = !self.newsTableView.editing;
    }else{
        if (self.infoTableView.editing == YES) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
        }else{
            self.navigationItem.rightBarButtonItem.title = @"完成";
        }
        self.infoTableView.editing = !self.infoTableView.editing;
    }
}

- (void)segmentAction:(UISegmentedControl *)sender
{
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    self.newsTableView.editing = NO;
    self.infoTableView.editing = NO;
    if (sender.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }else if (sender.selectedSegmentIndex == 1){
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
        }];
    }else{
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.newsTableView == tableView) {
        return self.newsArray.count;
    }else if (self.infoTableView == tableView){
        return self.infoArray.count;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDMCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMCollectCell" forIndexPath:indexPath];
    
    if (tableView == self.newsTableView) {
        MDMCollect *collect = [self.newsArray objectAtIndex:indexPath.section];
        cell.collect = collect;
    }else if (tableView == self.infoTableView){
        MDMCollect *collect = [self.infoArray objectAtIndex:indexPath.section];
        cell.collect = collect;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.newsTableView) {
        MDMCollect *collect = [self.newsArray objectAtIndex:indexPath.section];
        [collect deleteInBackground];
        [self.newsArray removeObjectAtIndex:indexPath.section];
        [self.newsTableView reloadData];
    }else if (tableView == self.infoTableView){
        MDMCollect *collect = [self.infoArray objectAtIndex:indexPath.section];
        [collect deleteInBackground];
        [self.infoArray removeObjectAtIndex:indexPath.section];
        [self.infoTableView reloadData];
    }else{
        return;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.newsTableView == tableView) {
        MDMCollect *collect = [self.newsArray objectAtIndex:indexPath.section];
        BJ_detailsPageViewController *vc = [[BJ_detailsPageViewController alloc] init];
        vc.ID = [collect.theId integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.infoTableView == tableView){
        
    }else{
        return;
    }
}

- (NSMutableArray *)newsArray
{
    if (_newsArray == nil) {
        self.newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

- (NSMutableArray *)infoArray
{
    if (_infoArray == nil) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

@end
