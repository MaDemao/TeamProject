//
//  MDMRegisterVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMRegisterVC.h"
#import "MDMMyUser.h"
#import "MDMUserInfo.h"
#import "MDMUserHelper.h"

@interface MDMRegisterVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwdText;
@property (weak, nonatomic) IBOutlet UIButton *reginBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation MDMRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self.reginBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    activityView.color = [UIColor blackColor];
    self.activityView = activityView;
    [self.view addSubview:activityView];
    self.usernameText.delegate = self;
    self.passwdText.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.usernameText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.usernameText resignFirstResponder];
    [self.passwdText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameText resignFirstResponder];
    [self.passwdText resignFirstResponder];
}

- (IBAction)registerBtnAction:(UIButton *)sender {
    
    [self.activityView startAnimating];
    
    if ([self.usernameText.text isEqualToString:@""] || [self.passwdText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (self.passwdText.text.length < 6 || self.passwdText.text.length >16){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码输入不合法" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        MDMMyUser *myuser = [MDMMyUser object];
        myuser.username = self.usernameText.text;
        myuser.password = self.passwdText.text;
        NSError *error = nil;
        [myuser signUp:&error];
        
        if (error.code == 202) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名已被占用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (error.code == 0){
            NSError *error1 = nil;
            AVUser *user = [MDMMyUser logInWithUsername:myuser.username password:myuser.password error:&error1];
            if (error1.code == 0) {
                MDMMyUser *current = (MDMMyUser *)user;
                
                MDMUserInfo *info = [MDMUserInfo object];
                info.username = myuser.username;
                info.name = myuser.username;
                
                UIImage *image = [UIImage imageNamed:@"iconfont-morentouxiang.png"];
                NSData *data = UIImageJPEGRepresentation(image, 0.1);
                AVFile *head = [AVFile fileWithData:data];
                [head save];
                info.image = head;
                
                [info save];
                current.info = info;
                [current save];
                
                [MDMUserHelper sharedMDMUserHelper].currentUser = current;
                
                if (self.theBlock) {
                    self.theBlock(NO, YES);
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功，登录失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络出错" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    [self.activityView stopAnimating];
}

@end
