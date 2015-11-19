//
//  MDMPostTVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMPostTVC.h"
#import "MDMPostCell.h"
#import "MDMUserHelper.h"
#import "MDMLoginVC.h"
#import "MDMPostEditVC.h"
#import "MDMPostDetailedVC.h"
#import "MDMUserDetailedVC.h"
#import <MJRefresh.h>

@interface MDMPostTVC ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation MDMPostTVC

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"论坛";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MDMPostCell" bundle:nil] forCellReuseIdentifier:@"PostCell"];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnAction:)];
    
    
    [MDMUserHelper sharedMDMUserHelper].thePostBlock = ^(){
        self.dataArray = [MDMUserHelper sharedMDMUserHelper].postArray;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    };
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    [self.view addSubview:self.activityView];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MDMUserHelper sharedMDMUserHelper].currentPage = 0;
        [[MDMUserHelper sharedMDMUserHelper] requestPostDataWithPage:[MDMUserHelper sharedMDMUserHelper].currentPage];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([MDMUserHelper sharedMDMUserHelper].currentPage <= [MDMUserHelper sharedMDMUserHelper].totilPage){
            [[MDMUserHelper sharedMDMUserHelper] requestPostDataWithPage:[MDMUserHelper sharedMDMUserHelper].currentPage];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isPush == YES) {
        MDMPostEditVC *vc = [[MDMPostEditVC alloc] init];
        vc.theBlock = ^(BOOL isRef,BOOL isPush){
            self.isRef = isRef;
            self.isPush = isPush;
        };
        self.isPush = NO;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.isRef == YES) {
        [self.tableView reloadData];
//        [[MDMUserHelper sharedMDMUserHelper] requestPostData];
        
        [self.tableView.mj_header beginRefreshing];
        
        self.isRef = NO;
    }
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        MDMPostEditVC *vc = [[MDMPostEditVC alloc] init];
        vc.theBlock = ^(BOOL isRef,BOOL isPush){
            self.isRef = isRef;
            self.isPush = isPush;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MDMLoginVC *vc = [[MDMLoginVC alloc] init];
        vc.theBlock = ^(BOOL isRef, BOOL isPush){
            self.isRef = isRef;
            self.isPush = isPush;
        };
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDMPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
    cell.post = post;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    [cell.headPic addGestureRecognizer:tapGR];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        [self.activityView startAnimating];
        MDMPostDetailedVC *vc = [[MDMPostDetailedVC alloc] init];
        vc.post = [self.dataArray objectAtIndex:indexPath.section];
        vc.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.activityView stopAnimating];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)tapGRAction:(UITapGestureRecognizer *)sender
{
    if (self.dataArray.count > 0) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:((MDMPostCell *)(sender.view.superview.superview.superview))];
        MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
        MDMUserInfo *info = post.info;
        
        MDMUserDetailedVC *vc = [[MDMUserDetailedVC alloc] init];
        vc.info = info;
        [self.navigationController pushViewController:vc animated:YES];
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