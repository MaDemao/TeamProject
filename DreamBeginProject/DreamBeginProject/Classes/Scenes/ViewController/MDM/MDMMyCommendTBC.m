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

@interface MDMMyCommendTBC ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation MDMMyCommendTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    [self.view addSubview:self.activityView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MDMMyCommendCell" bundle:nil] forCellReuseIdentifier:@"MDMMyCommendCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    
    AVQuery *query = [MDMCommend query];
    [query whereKey:@"info" equalTo:self.info];
    [query orderByDescending:@"date"];
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

    MDMCommend *commend = [self.dataArray objectAtIndex:indexPath.section];
    
    cell.commend = commend;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
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
