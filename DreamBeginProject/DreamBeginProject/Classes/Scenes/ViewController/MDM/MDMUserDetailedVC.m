//
//  MDMUserDetailedVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserDetailedVC.h"
#import "MDMCommend.h"
#import "MDMPost.h"
#import "MDMPostDetailedVC.h"
#import "MDMMyCommendTBC.h"
#import "MDMUserHelper.h"
#import "MDMFans.h"
#import "MDMLoginVC.h"
#import "MDMMyAttentionTVC.h"
#import "MDMMyFansTVC.h"
#import <MJRefresh.h>

@interface MDMUserDetailedVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *personText;
@property (weak, nonatomic) IBOutlet UILabel *commendText;
@property (weak, nonatomic) IBOutlet UILabel *attentionText;
@property (weak, nonatomic) IBOutlet UILabel *fansText;
@property (weak, nonatomic) IBOutlet UIView *commendView;
@property (weak, nonatomic) IBOutlet UIView *attentionView;
@property (weak, nonatomic) IBOutlet UIView *fansView;



@property (weak, nonatomic) IBOutlet UIButton *funsBtn;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isFans;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;


@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totilePage;

@end

@implementation MDMUserDetailedVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    [self.view addSubview:self.activityView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headPic.image = [UIImage imageNamed:@"iconfont-morentouxiang.png"];
    self.headPic.layer.masksToBounds = YES;
    self.headPic.layer.cornerRadius = self.headPic.frame.size.height / 2.;
    
    UITapGestureRecognizer *tapGRCommend = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRCommendAction:)];
    [self.commendView addGestureRecognizer:tapGRCommend];
    
    UITapGestureRecognizer *tapGRAttention = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAttentionAction:)];
    [self.attentionView addGestureRecognizer:tapGRAttention];
    
    UITapGestureRecognizer *tapGRFans = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRFansAction:)];
    [self.fansView addGestureRecognizer:tapGRFans];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentPage < self.totilePage) {
            AVQuery *query = [MDMPost query];
            [query whereKey:@"info" equalTo:self.info];
            [query orderByDescending:@"date"];
            [query includeKey:@"images"];
            query.limit = 7;
            self.currentPage++;
            query.skip = 7 * (self.currentPage - 1);
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dataArray addObjectsFromArray:objects];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
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
    
    AVQuery *queryQ = [MDMPost query];
    [queryQ whereKey:@"info" equalTo:self.info];
    [queryQ countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.totilePage = number / 7;
        self.currentPage = 1;
        
        if (self.currentPage <= self.totilePage + 1) {
            AVQuery *query = [MDMPost query];
            [query whereKey:@"info" equalTo:self.info];
            [query orderByDescending:@"date"];
            [query includeKey:@"images"];
            query.limit = 7;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dataArray addObjectsFromArray:objects];
                    [self.tableView reloadData];
                });
            }];
        }
    }];
    
    
    AVFile *avfile = self.info.image;
    NSData *data = [avfile getData];
    self.headPic.image = [UIImage imageWithData:data];
    self.nameText.text = self.info.name;
    self.personText.text = self.info.personality;
    
    AVQuery *query1 = [MDMCommend query];
    [query1 whereKey:@"info" equalTo:self.info];
    [query1 countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.commendText.text = [NSString stringWithFormat:@"%ld", number];
    }];
    
    AVQuery *query2 = [MDMFans query];
    [query2 whereKey:@"fromInfo" equalTo:self.info];
    [query2 countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.attentionText.text = [NSString stringWithFormat:@"%ld", number];
    }];
    
    AVQuery *query3 = [MDMFans query];
    [query3 whereKey:@"toInfo" equalTo:self.info];
    [query3 countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.fansText.text = [NSString stringWithFormat:@"%ld", number];
    }];
    
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        if ([self.info.objectId isEqualToString:[MDMUserHelper sharedMDMUserHelper].currentUser.info.objectId]) {
            self.funsBtn.hidden = YES;
        }else{
            AVQuery *query1 = [MDMFans query];
            [query1 whereKey:@"fromInfo" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
            AVQuery *query2 = [MDMFans query];
            [query2 whereKey:@"toInfo" equalTo:self.info];
            AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (objects.count > 0) {
                        [self.funsBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                        self.isFans = YES;
                    }else{
                        [self.funsBtn setTitle:@"关注" forState:UIControlStateNormal];
                        self.isFans = NO;
                    }
                });
            }];
        }
    }
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fansBtnAction:(UIButton *)sender {
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        if ([self.info.objectId isEqualToString:[MDMUserHelper sharedMDMUserHelper].currentUser.info.objectId]) {
            return;
        }else{
            if (self.isFans) {
                //删除关系
                
                AVQuery *query1 = [MDMFans query];
                [query1 whereKey:@"fromInfo" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
                AVQuery *query2 = [MDMFans query];
                [query2 whereKey:@"toInfo" equalTo:self.info];
                AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (objects.count > 0) {
                            MDMFans *fans = objects.firstObject;
                            [self.activityView startAnimating];
                            NSLog(@"%@", fans);
                            [fans deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                self.isFans = NO;
                                [self.funsBtn setTitle:@"关注" forState:UIControlStateNormal];
                                [self viewWillAppear:YES];
                                [self.activityView stopAnimating];
                            }];
                        }
                    });
                }];
                
                
            }else{
                [self.activityView startAnimating];
                MDMFans *fans = [MDMFans object];
                fans.fromInfo = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
                fans.toInfo = self.info;
                
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH-mm:ss"];
                NSString *string = [formatter stringFromDate:date];
                
                fans.date = string;
                [fans save];
                
                self.isFans = YES;
                [self.funsBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                [self viewWillAppear:YES];
                [self.activityView stopAnimating];
            }
        }
    }else
    {
        MDMLoginVC *vc = [[MDMLoginVC alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)tapGRCommendAction:(UITapGestureRecognizer *)sender
{
    MDMMyCommendTBC *tbc = [[MDMMyCommendTBC alloc] init];
    tbc.info = self.info;
    [self.navigationController pushViewController:tbc animated:YES];
}

- (void)tapGRAttentionAction:(UITapGestureRecognizer *)sender
{
    MDMMyAttentionTVC *tvc = [[MDMMyAttentionTVC alloc] init];
    tvc.info = self.info;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)tapGRFansAction:(UITapGestureRecognizer *)sender
{
    MDMMyFansTVC *tvc = [[MDMMyFansTVC alloc] init];
    tvc.info = self.info;
    [self.navigationController pushViewController:tvc animated:YES];
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserPostCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UserPostCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:24];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    
    if (self.dataArray.count > 0) {
        MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
        cell.textLabel.text = post.title;
        cell.detailTextLabel.text = post.des;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 1;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
        
        MDMPostDetailedVC *vc = [[MDMPostDetailedVC alloc] init];
        
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
