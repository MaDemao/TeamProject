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

@interface MDMPostEditVC ()<UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *desText;
@property (weak, nonatomic) IBOutlet UILabel *tempText;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
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
    return self.imageArray.count + 1;
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
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing=NO;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info1
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(delayAction:) withObject:info1 afterDelay:0.1];
}

- (void)delayAction:(NSDictionary *)info1
{
    UIImage * image=[info1 objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageArray addObject:image];
    [self.collectionView reloadData];
    [self.titleText resignFirstResponder];
    [self.desText resignFirstResponder];
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.imageArray.count inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
