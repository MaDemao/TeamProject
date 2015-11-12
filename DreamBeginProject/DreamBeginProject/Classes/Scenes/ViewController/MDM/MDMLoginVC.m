//
//  MDMLoginVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMLoginVC.h"
#import "MDMRegisterVC.h"
#import "MDMMyUser.h"
#import "MDMUserHelper.h"

@interface MDMLoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwdText;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation MDMLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    
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

- (IBAction)loginBtnAction:(UIButton *)sender {
    [self.activityView startAnimating];
    
    if ([self.usernameText.text isEqualToString:@""] || [self.passwdText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSError *error = nil;
        AVUser *user = [MDMMyUser logInWithUsername:self.usernameText.text password:self.passwdText.text error:&error];
        NSInteger code = error.code;
//        NSLog(@"%ld", code);
        if (code == 211) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名不存在" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else if(code == 210){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else if(code == 0){
            [MDMUserHelper sharedMDMUserHelper].currentUser = (MDMMyUser *)user;
            
            if (self.theBlock) {
                self.theBlock(NO, YES);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    [self.activityView stopAnimating];
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    MDMRegisterVC *vc = [[MDMRegisterVC alloc] init];
    vc.theBlock = ^(BOOL isRef, BOOL isPush){
        if (self.theBlock) {
            self.theBlock(isRef, isPush);
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
