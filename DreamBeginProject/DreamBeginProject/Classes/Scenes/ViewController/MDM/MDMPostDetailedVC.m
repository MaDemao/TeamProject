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
#import "MDMUserDetailedVC.h"
#import "LGPhoto.h"

@interface MDMPostDetailedVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LGPhotoPickerBrowserViewControllerDelegate, LGPhotoPickerBrowserViewControllerDataSource>
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
@property (weak, nonatomic) IBOutlet UIView *tempView;

@property (nonatomic, strong) NSMutableArray *LGPhotoPickerBrowserPhotoArray;

@property (nonatomic, assign) LGShowImageType showType;
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
    
    UITapGestureRecognizer *tapGRHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRHeadAction:)];
    self.headPic.userInteractionEnabled = YES;
    [self.headPic addGestureRecognizer:tapGRHead];
}

- (void)tapGRViewAction:(UITapGestureRecognizer *)sender
{
    MDMCommendTBC *vc = [[MDMCommendTBC alloc] init];
    vc.post = self.post;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapGRHeadAction:(UITapGestureRecognizer *)sender
{
    MDMUserDetailedVC *vc = [[MDMUserDetailedVC alloc] init];
    vc.info = self.post.info;
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
        self.tempView.hidden = YES;
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headPic.image = [UIImage imageWithData:data];
            self.headPic.layer.masksToBounds = YES;
            self.headPic.layer.cornerRadius = self.headPic.frame.size.height / 2.;
            self.nameText.text = info.name;
            self.personText.text = info.personality;
        });
        
    }];
    [self.LGPhotoPickerBrowserPhotoArray removeAllObjects];
    for (AVFile *avfile in self.post.images) {
        NSData *data = [avfile getData];
        UIImage *image = [UIImage imageWithData:data];
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        photo.photoImage = image;
        [self.LGPhotoPickerBrowserPhotoArray addObject:photo];
    }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageBroswer];
    
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = LGShowImageTypeImageBroswer;
    self.showType = LGShowImageTypeImageBroswer;
    BroswerVC.currentIndexPath = indexPath;
    [self presentViewController:BroswerVC animated:YES completion:nil];
}

/*
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = style;
    self.showType = style;
//    BroswerVC.currentIndexPath = 
    [self presentViewController:BroswerVC animated:YES completion:nil];
}
*/
#pragma mark - LGPhotoPickerBrowserViewControllerDataSource
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{if (self.showType == LGShowImageTypeImageBroswer) {
    return self.LGPhotoPickerBrowserPhotoArray.count;
    } else {
       // NSLog(@"非法数据源");
        return 0;
    }
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showType == LGShowImageTypeImageBroswer) {
        return [self.LGPhotoPickerBrowserPhotoArray objectAtIndex:indexPath.item];
    } else {
        NSLog(@"非法数据源");
        return nil;
    }
}

- (NSMutableArray *)LGPhotoPickerBrowserPhotoArray
{
    if (_LGPhotoPickerBrowserPhotoArray == nil) {
        self.LGPhotoPickerBrowserPhotoArray = [NSMutableArray array];
    }
    return _LGPhotoPickerBrowserPhotoArray;
}

@end
