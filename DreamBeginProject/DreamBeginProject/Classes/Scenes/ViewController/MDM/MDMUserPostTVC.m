//
//  MDMUserPostTVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserPostTVC.h"
#import "MDMUserPostCell.h"
#import "MDMPost.h"
#import "MDMPostDetailedVC.h"
#import <MJRefresh.h>

@interface MDMUserPostTVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger totilPage;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MDMUserPostTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的帖子";
    [self.tableView registerNib:[UINib nibWithNibName:@"MDMUserPostCell" bundle:nil] forCellReuseIdentifier:@"MDMUserPostCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentPage <= self.totilPage) {
            AVQuery *query = [MDMPost query];
            [query whereKey:@"info" equalTo:self.info];
            [query includeKey:@"images"];
            [query orderByDescending:@"date"];
            query.limit = 7;
            self.currentPage++;
            query.skip = 7 * (self.currentPage - 1);
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [self.dataArray addObjectsFromArray:objects];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    AVQuery *query1 = [MDMPost query];
    [query1 whereKey:@"info" equalTo:self.info];
    [query1 countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.totilPage = number / 7;
        self.currentPage = 1;
    }];
    
    AVQuery *query = [MDMPost query];
    [query whereKey:@"info" equalTo:self.info];
    [query includeKey:@"images"];
    [query orderByDescending:@"date"];
    query.limit = 7;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            [self.dataArray addObjectsFromArray:objects];
            [self.tableView reloadData];
        }
    }];
}


- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    if (self.tableView.editing == YES) {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }else{
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }
    self.tableView.editing = !self.tableView.editing;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDMUserPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMUserPostCell" forIndexPath:indexPath];
    
    if (self.dataArray.count > 0) {
        MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
        cell.post = post;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    if (self.dataArray.count > 0) {
        MDMPost *post = [self.dataArray objectAtIndexedSubscript:indexPath.section];
        [self.dataArray removeObject:post];
        [post delete];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        MDMPostDetailedVC *vc = [[MDMPostDetailedVC alloc] init];
        MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
        vc.post = post;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
