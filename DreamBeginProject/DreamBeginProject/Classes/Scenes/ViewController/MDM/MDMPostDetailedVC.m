//
//  MDMPostDetailedVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMPostDetailedVC.h"
#import "MDMPicItem.h"
#import "MDMCommendTBC.h"
#import "MDMCommend.h"

@interface MDMPostDetailedVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *personText;
@property (weak, nonatomic) IBOutlet UILabel *commendCountText;
@property (weak, nonatomic) IBOutlet UIView *commendView;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *desText;
@property (weak, nonatomic) IBOutlet UICollectionView *pics;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MDMPostDetailedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    self.pics.delegate = self;
    self.pics.dataSource = self;
    [self.pics registerNib:[UINib nibWithNibName:@"MDMPicItem" bundle:nil] forCellWithReuseIdentifier:@"MDMPicItem"];
    
    UITapGestureRecognizer *tapGRView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRViewAction:)];
    [self.commendView addGestureRecognizer:tapGRView];
}

- (void)tapGRViewAction:(UITapGestureRecognizer *)sender
{
    MDMCommendTBC *vc = [[MDMCommendTBC alloc] init];
    vc.post = self.post;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MDMUserInfo *info = self.post.info;
    
    if (self.post.images.count == 0) {
        self.hight.constant = 0;
        [self.pics setNeedsUpdateConstraints];
        [self.pics updateConstraintsIfNeeded];
    }
    
    self.titleText.text = self.post.title;
    self.desText.text = self.post.des;
    
    AVQuery *query = [MDMCommend query];
    [query whereKey:@"post" equalTo:self.post];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (number >= 1024) {
            number = number / 1024.;
            self.commendCountText.text = [NSString stringWithFormat:@"%.2fK", (double)number];
        }else{
            self.commendCountText.text = [NSString stringWithFormat:@"%ld", number];
        }
    }];
    
    [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        AVFile *avfile = info.image;
        NSData *data = [avfile getData];
        self.headPic.image = [UIImage imageWithData:data];
        self.headPic.layer.masksToBounds = YES;
        self.headPic.layer.cornerRadius = self.headPic.frame.size.height / 2.;
        self.nameText.text = info.name;
        self.personText.text = info.personality;
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.post.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDMPicItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"MDMPicItem" forIndexPath:indexPath];
    
    AVFile *avfile = [self.post.images objectAtIndex:indexPath.item];
    NSData *data = [avfile getData];
    item.imgView.image = [UIImage imageWithData:data];
    
    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 140);
}

@end
