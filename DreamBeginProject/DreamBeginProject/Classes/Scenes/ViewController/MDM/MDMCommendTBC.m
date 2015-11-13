//
//  MDMCommendTBC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMCommendTBC.h"
#import "MDMCommend.h"
#import "MDMCommendEditVC.h"
#import "MDMUserHelper.h"
#import "MDMLoginVC.h"
#import "MDMCommendCell.h"
#import "MDMUserDetailedVC.h"

@interface MDMCommendTBC ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MDMCommendTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写评论" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    
    self.title = @"评论";
    self.isPush = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MDMCommendCell" bundle:nil] forCellReuseIdentifier:@"MDMCommendCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        MDMCommendEditVC *vc = [[MDMCommendEditVC alloc] init];
        vc.post = self.post;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MDMLoginVC *vc = [[MDMLoginVC alloc] init];
        vc.theBlock = ^(BOOL isRef, BOOL isPush){
            self.isPush = isPush;
        };
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isPush == YES) {
        [self rightBtnAction:nil];
        self.isPush = NO;
    }else{
        [self.dataArray removeAllObjects];
        
        AVQuery *query = [MDMCommend query];
        [query whereKey:@"post" equalTo:self.post];
        [query orderByDescending:@"date"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects) {
                [self.dataArray addObjectsFromArray:objects];
                [self.tableView reloadData];
            }
        }];
    }
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
    MDMCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMCommendCell" forIndexPath:indexPath];
    
    MDMCommend *commend = [self.dataArray objectAtIndex:indexPath.section];
    
    cell.commend = commend;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    [cell.headPic addGestureRecognizer:tapGR];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tapGRAction:(UITapGestureRecognizer *)sender
{
    NSIndexPath *path = [self.tableView indexPathForCell:((MDMCommendCell *)sender.view.superview.superview)];
    if (self.dataArray.count > 0) {
        MDMCommend *commend = [self.dataArray objectAtIndex:path.section];
        
        MDMUserDetailedVC *vc = [[MDMUserDetailedVC alloc] init];
        vc.info = commend.info;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
