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

@end

@implementation MDMUserDetailedVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AVQuery *query = [MDMPost query];
    [query whereKey:@"info" equalTo:self.info];
    [query orderByDescending:@"date"];
    [query includeKey:@"images"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.dataArray addObjectsFromArray:objects];
        [self.tableView reloadData];
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
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fansBtnAction:(UIButton *)sender {
}

- (void)tapGRCommendAction:(UITapGestureRecognizer *)sender
{
    MDMMyCommendTBC *tbc = [[MDMMyCommendTBC alloc] init];
    tbc.info = self.info;
    [self.navigationController pushViewController:tbc animated:YES];
}

- (void)tapGRAttentionAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"关注");
}

- (void)tapGRFansAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"粉丝");
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
    
    MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.des;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDMPost *post = [self.dataArray objectAtIndex:indexPath.section];
    
    MDMPostDetailedVC *vc = [[MDMPostDetailedVC alloc] init];
    
    vc.post = post;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
