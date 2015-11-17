//
//  MDMUserCommendTVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserCommendTVC.h"
#import "MDMCommend.h"
#import "MDMUserCommendCell.h"
#import "MDMPostDetailedVC.h"
#import <MJRefresh.h>

@interface MDMUserCommendTVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger totilPage;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation MDMUserCommendTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    [self.view addSubview:self.activityView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"MDMUserCommendCell" bundle:nil] forCellReuseIdentifier:@"MDMUserCommendCell"];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentPage <= self.totilPage) {
            AVQuery *query = [MDMCommend query];
            [query whereKey:@"info" equalTo:self.info];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    AVQuery *query1 = [MDMCommend query];
    [query1 whereKey:@"info" equalTo:self.info];
    [query1 countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.totilPage = number / 7;
        self.currentPage = 1;
    }];
    
    AVQuery *query = [MDMCommend query];
    [query whereKey:@"info" equalTo:self.info];
    [query orderByDescending:@"date"];
    query.limit = 7;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.dataArray addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDMUserCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMUserCommendCell" forIndexPath:indexPath];
    
    if (self.dataArray.count > 0) {
        MDMCommend *commend = [self.dataArray objectAtIndex:indexPath.section];
        cell.commend = commend;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
        MDMCommend *commend = [self.dataArray objectAtIndex:indexPath.section];
        [self.dataArray removeObject:commend];
        [commend deleteInBackground];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        [self.activityView startAnimating];
        MDMPostDetailedVC *vc = [[MDMPostDetailedVC alloc] init];
        MDMCommend *commend = [self.dataArray objectAtIndex:indexPath.section];
        AVQuery *query = [MDMPost query];
        [query whereKey:@"objectId" equalTo:commend.post.objectId];
        [query includeKey:@"images"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                MDMPost *post = objects.firstObject;
                vc.post = post;
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nc animated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络出错" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [self.activityView stopAnimating];
        }];
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
