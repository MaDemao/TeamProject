//
//  MDMMyCommendTBC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMMyCommendTBC.h"
#import "MDMPostDetailedVC.h"
#import "MDMMyCommendCell.h"
#import <MJRefresh.h>

@interface MDMMyCommendTBC ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totilPage;
@end

@implementation MDMMyCommendTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    [self.view addSubview:self.activityView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MDMMyCommendCell" bundle:nil] forCellReuseIdentifier:@"MDMMyCommendCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    [self.navigationController popViewControllerAnimated:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDMMyCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMMyCommendCell" forIndexPath:indexPath];

    if (self.dataArray.count > 0) {
        MDMCommend *commend = [self.dataArray objectAtIndex:indexPath.section];
        
        cell.commend = commend;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        MDMCommend *commend = [self.dataArray objectAtIndex:indexPath.section];
        MDMPost *post = commend.post;
        AVQuery *query = [MDMPost query];
        [query whereKey:@"objectId" equalTo:post.objectId];
        [query includeKey:@"images"];
        [self.activityView startAnimating];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            MDMPostDetailedVC *vc = [[MDMPostDetailedVC alloc] init];
            
            if (objects.count > 0) {
                vc.post = objects.firstObject;
                
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
