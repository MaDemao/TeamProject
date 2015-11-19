//
//  LANInfoVC.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANInfoVC.h"
#import "LANInfoModel.h"

#import <AVUser.h>

#import "UMSocial.h"

#import "MDMUserHelper.h"
#import "MDMLoginVC.h"



@interface LANInfoVC ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)NSString *Str;

@property (nonatomic, copy) NSString *titleStr;

@end

@implementation LANInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _index=0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    //self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImage *image = [UIImage imageNamed:@"7.png"];
    UIImage *image1 = [UIImage imageNamed:@"5.png"];
    UIImage *image2 = [UIImage imageNamed:@"3.png"];
    
    //视图可见
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //分享
    UIBarButtonItem *rightOne = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(button3Action:)];
    
    //收藏
    UIBarButtonItem *rightTwo = [[UIBarButtonItem alloc]initWithImage:image2 style:UIBarButtonItemStylePlain target:self action:@selector(button2Action:)];
    //改变字体
    UIBarButtonItem *rightThree = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(button1Action:)];
    self.navigationItem.rightBarButtonItems = @[rightOne,rightTwo,rightThree];
 
    self.titleStr = self.infoModel.infoTitle;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //self.webView.delegate = self;
    
    [self requestData];
    
}


-(void)requestData{
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *string =[NSString stringWithFormat:@"http://api.lkhealth.net/index.php?r=news/newsdetail&dataId=%@&dataType=0&isAlbum=0",self.infoModel.infoId];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        
        NSURL *url = [NSURL URLWithString:string];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dict = [rootDic objectForKey:@"data"];
            NSDictionary *dic = [dict objectForKey:@"newsInfo"];
            NSString *string = [dic objectForKey:@"content"];
//            NSLog(@"%@", string);
            self.Str = [NSString stringWithString:string];
            
            [self.webView loadHTMLString:string baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [self.view addSubview:self.webView];
            
            [self.view addSubview:self.webView];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
            
        }];
        [dataTask resume];

        
    });
    
    
    
    
}

//取html标签
- (NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    return html;
    
}



//字体大小
-(void)button1Action:(id)sender{
    _index++;
    if (_index == 1) {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    }else if (_index == 2){
       
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '180%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    } else if (_index == 3){
        _index = 0;
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '60%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    }
   
    
    
    
}
//收藏
-(void)button2Action:(UIBarButtonItem *)sender{
   
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        
        if ([MDMUserHelper isCollectOfLAN:self.infoModel.infoId]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经收藏" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0];
        }else{
            if (self.titleStr) {
                [MDMUserHelper collectOfLAN:self.infoModel.infoId title:self.titleStr];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"内容未加载完成" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0];
            }
        }
    }else{
        MDMLoginVC *vc = [[MDMLoginVC alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)dismissAlert:(UIAlertController *)sender
{
    [sender dismissViewControllerAnimated:YES completion:nil];
}

//分享
-(void)button3Action:(UIBarButtonItem *)sender{
  
    
    
    
        // 允许用户使用应用
        NSString *st = [self filterHTML:self.Str];
    
    if (st.length > 130) {
        st = [st substringToIndex:129];
        st = [st stringByAppendingString:@"..."];
    }
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"5646898a67e58e8c57002553"
                                          shareText:st
                                         shareImage:[UIImage imageNamed:@"icon.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToDouban,UMShareToEmail, nil]
                                           delegate:nil];
        

        
    

    
    
    
}




//返回上一个页面

-(void)leftAction:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
