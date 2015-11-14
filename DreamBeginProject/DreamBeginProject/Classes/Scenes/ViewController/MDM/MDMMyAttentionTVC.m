//
//  MDMMyAttentionTVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMMyAttentionTVC.h"
#import "MDMRelationCell.h"
#import "MDMUserDetailedVC.h"

@interface MDMMyAttentionTVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation MDMMyAttentionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    [self.view addSubview:self.activityView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MDMRelationCell" bundle:nil] forCellReuseIdentifier:@"MDMRelationCell"];
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    if (self.pushType == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    AVQuery *query = [MDMFans query];
    [query whereKey:@"fromInfo" equalTo:self.info];
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
    MDMRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMRelationCell" forIndexPath:indexPath];
    
    if (self.dataArray.count > 0) {
        MDMFans *fans = [self.dataArray objectAtIndex:indexPath.section];
        MDMUserInfo *info = fans.toInfo;
        
        [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            cell.info = info;
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.activityView startAnimating];
    if (self.dataArray.count > 0) {
        MDMFans *fans = [self.dataArray objectAtIndex:indexPath.section];
        MDMUserInfo *info = fans.toInfo;
        
        [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            MDMUserDetailedVC *vc = [[MDMUserDetailedVC alloc] init];
            vc.info = info;
            [self.activityView stopAnimating];
            [self.navigationController pushViewController:vc animated:YES];
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
