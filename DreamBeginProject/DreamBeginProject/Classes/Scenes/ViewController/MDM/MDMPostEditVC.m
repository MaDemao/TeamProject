//
//  MDMPostEditVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMPostEditVC.h"
#import "MDMPicItem.h"
#import "MDMPost.h"
#import "MDMUserHelper.h"
#import "LGPhoto.h"

@interface MDMPostEditVC ()<UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LGPhotoPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *desText;
@property (weak, nonatomic) IBOutlet UILabel *tempText;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, assign) LGShowImageType showType;
@end

@implementation MDMPostEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 100);
    [self.view addSubview:self.activityView];
    
    self.desText.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MDMPicItem" bundle:nil] forCellWithReuseIdentifier:@"MDMPicItem"];
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    if (self.imageArray.count > 0 || [self.titleText.text isEqualToString:@""] == NO || [self.desText.text isEqualToString:@""] == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"还未保存，是否保存" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action1];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    if ([self.titleText.text isEqualToString:@""] || [self.desText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"标题和内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        [self.activityView startAnimating];
        
        MDMPost *post = [MDMPost object];
        post.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
        post.title = self.titleText.text;
        post.des = self.desText.text;
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *string = [formatter stringFromDate:date];
        post.date = string;
        
        NSMutableArray *array = [NSMutableArray array];
        for (UIImage *image in self.imageArray) {
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            AVFile *file = [AVFile fileWithData:data];
            [file save];
            [array addObject:file];
        }
        post.images = array;
        [post save];
        [array removeAllObjects];
        [self.activityView stopAnimating];
        
        self.theBlock(YES, NO);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.titleText becomeFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.titleText resignFirstResponder];
    [self.desText resignFirstResponder];
}



#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.tempText.hidden = NO;
    }else{
        self.tempText.hidden = YES;
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArray.count == 9) {
        return 9;
    }else{
        return self.imageArray.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDMPicItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"MDMPicItem" forIndexPath:indexPath];
    
    if (indexPath.item < self.imageArray.count) {
        item.imgView.image = [self.imageArray objectAtIndex:indexPath.item];
    }else{
        item.imgView.image = [UIImage imageNamed:@"iconfont-tianjiazhaopian.png"];
    }
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < self.imageArray.count) {
        [self.titleText resignFirstResponder];
        [self.desText resignFirstResponder];
    }else{
        [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
    }
}

- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    // 创建控制器
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // 最多能选9张图片
    pickerVc.maxCount = 9 - self.imageArray.count;
    pickerVc.delegate = self;
    self.showType = style;
    [pickerVc showPickerVc:self];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
//    NSLog(@"%@", [(LGPhotoAssets *)(assets.firstObject) originImage]);
    for (LGPhotoAssets *asse in assets) {
        [self.imageArray addObject:asse.originImage];
    }
    [self.collectionView reloadData];
    [self.titleText resignFirstResponder];
    [self.desText resignFirstResponder];
//    NSIndexPath *path = [NSIndexPath indexPathForItem:self.imageArray.count + 1 inSection:0];
////    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}


 
#pragma mark - 懒加载
- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        self.imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

@end
