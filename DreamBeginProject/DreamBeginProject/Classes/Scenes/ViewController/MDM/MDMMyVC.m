//
//  MDMMyVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMMyVC.h"
#import "MDMLoginVC.h"
#import "MDMUserHelper.h"
#import "MDMMyAttentionTVC.h"
#import "MDMMyFansTVC.h"
#import "MDMUserPostTVC.h"
#import "MDMUserCommendTVC.h"

@interface MDMMyVC ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@end

@implementation MDMMyVC

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"我的";
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    self.dataArray = nil;
    NSString *string = [[NSBundle mainBundle] pathForResource:@"myData" ofType:@"plist"];
    self.dataArray = [NSMutableArray arrayWithContentsOfFile:string];
}


static NSString * const cell_id = @"cell_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    [MDMMyUser logOut];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell_id];

}

- (void)tapGRAction:(UITapGestureRecognizer *)sender
{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info1
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(delayAction:) withObject:info1 afterDelay:0.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)delayAction:(NSDictionary *)info1
{
    UIImage * image=[info1 objectForKey:UIImagePickerControllerEditedImage];
    MDMUserInfo *info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
    [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        AVFile *avfile = info.image;
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        AVFile *newAvfile = [AVFile fileWithData:data];
        [newAvfile save];
        info.image = newAvfile;
        [info save];
        [avfile deleteInBackground];
        [self viewWillAppear:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"%@", [MDMMyUser currentUser]);
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        
        
        [self.headPic addGestureRecognizer:self.tapGR];
        
        MDMMyUser *myUser = [MDMUserHelper sharedMDMUserHelper].currentUser;
        MDMUserInfo *info = myUser.info;
        [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            AVFile *head = info.image;
            NSData *data = [head getData];
//            NSLog(@"%@", head);
            self.headPic.image = [UIImage imageWithData:data];
        }];
        
        [self.loginBtn setTitle:@"注销" forState:UIControlStateNormal];
    }else{
        [self.headPic removeGestureRecognizer:self.tapGR];
        self.headPic.image = [UIImage imageNamed:@"iconfont-morentouxiang.png"];
        [self.loginBtn setTitle:@"前往登录" forState:UIControlStateNormal];
    }
    
    self.headPic.layer.masksToBounds = YES;
    _headPic.layer.cornerRadius = [UIScreen mainScreen].bounds.size.height * 0.3 * 0.4 / 2;

    [self.tableView reloadData];
}


- (IBAction)loginBtnAction:(UIButton *)sender {
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        [MDMMyUser logOut];
        [MDMUserHelper sharedMDMUserHelper].currentUser = nil;
        [self viewWillAppear:YES];
    }else{
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[MDMLoginVC alloc] init]];
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
    return [[self.dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    cell.textLabel.text = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2)) {
        if (indexPath.row == 2) {
            //清除缓存
        }else{
            //地图
        }
    }else{
        if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    //我的关注
                    MDMMyAttentionTVC *tvc = [[MDMMyAttentionTVC alloc] init];
                    tvc.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
                    tvc.pushType = 1;
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
                    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:nc animated:YES completion:nil];
                }else{
                    MDMMyFansTVC *tvc = [[MDMMyFansTVC alloc] init];
                    tvc.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
                    tvc.pushType = 1;
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
                    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:nc animated:YES completion:nil];
                }
            }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    //我的帖子
                    MDMUserPostTVC *tvc = [[MDMUserPostTVC alloc] init];
                    tvc.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
                    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:nc animated:YES completion:nil];
                }else if (indexPath.row == 1){
                    //我的评论
                    MDMUserCommendTVC *tvc = [[MDMUserCommendTVC alloc] init];
                    tvc.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
                    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:nc animated:YES completion:nil];
                }else{
                    //我的收藏
                }
            }else{
                //个人设置
            }
        }else{
            MDMLoginVC *vc = [[MDMLoginVC alloc] init];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
        }
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
