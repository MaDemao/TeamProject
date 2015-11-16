//
//  MDMUserSettingVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/16.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserSettingVC.h"
#import "MDMUserHelper.h"

@interface MDMUserSettingVC ()<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextView *personText;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;


@property (nonatomic, strong) MDMUserInfo *info;


@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation MDMUserSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2., [UIScreen mainScreen].bounds.size.height / 2.);
    [self.view addSubview:self.activityView];
    
    self.headPic.image = [UIImage imageNamed:@"iconfont-morentouxiang.png"];
    self.headPic.layer.masksToBounds = YES;
    self.headPic.layer.cornerRadius = self.headPic.frame.size.width / 2.;
    
    self.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
    
    self.nameText.delegate = self;
    self.personText.delegate = self;
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"保存"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self rightBtnAction:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@""]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        return;
    }
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    [self.activityView startAnimating];
    
    self.info.name = self.nameText.text;
    self.info.personality = self.personText.text;
    [self.info save];
    sender.title = @"";
    
    [self.nameText resignFirstResponder];
    [self.personText resignFirstResponder];
    
    [self.activityView stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        self.nameText.text = self.info.name;
        self.personText.text = self.info.personality;
        
        AVFile *avfile = self.info.image;
        NSData *data = [avfile getData];
        self.headPic.image = [UIImage imageWithData:data];
    }];
}

- (IBAction)btnAction:(UIButton *)sender {
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.title = @"保存";
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.title = @"保存";
}

@end
