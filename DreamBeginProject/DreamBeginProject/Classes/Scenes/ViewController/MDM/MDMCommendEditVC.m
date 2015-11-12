//
//  MDMCommendEditVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMCommendEditVC.h"
#import "MDMCommend.h"
#import "MDMUserHelper.h"

@interface MDMCommendEditVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botton;


@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation MDMCommendEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.textView.delegate = self;
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor blackColor];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    
    [self.view addSubview:self.activityView];
}

- (void)leftBtnAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    if ([self.textView.text isEqualToString:@""]) {
        
    }else{
        [self.activityView startAnimating];
        
        MDMCommend *commend = [MDMCommend object];
        commend.post = self.post;
        commend.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
        commend.des = self.textView.text;
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *string = [formatter stringFromDate:date];
        commend.date = string;
        [commend save];
        
        [self.activityView stopAnimating];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""] == NO) {
        self.textField.hidden = YES;
    }else{
        self.textField.hidden = NO;
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    self.botton.constant = height + 10;
    [self.textView setNeedsUpdateConstraints];
    [self.textView updateConstraintsIfNeeded];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.botton.constant = 0;
    [self.textView setNeedsUpdateConstraints];
    [self.textView updateConstraintsIfNeeded];
}

@end
