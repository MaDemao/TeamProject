//
//  LANInfoVC.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANInfoVC.h"
#import "LANInfoModel.h"
@interface LANInfoVC ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,assign)NSInteger index;

@end

@implementation LANInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _index=0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *tools = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 10, 150, 45)];
    [tools setTintColor:[UIColor orangeColor]];
    
    NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:2];
    
   // UIBarButtonItem *button1 = [[UIBarButtonItem alloc]initWithImage:nil style:(UIBarButtonItemStylePlain) target:self action:@selector(button1Action:)];
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc]initWithTitle:@"字体" style:(UIBarButtonItemStylePlain) target:self action:@selector(button1Action:)];
    
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:(UIBarButtonItemStylePlain) target:self action:@selector(button2Action:)];
    
   // UIBarButtonItem *button2 = [[UIBarButtonItem alloc]initWithImage:nil style:(UIBarButtonItemStylePlain) target:self action:@selector(button2Action:)];
    
    UIBarButtonItem *button3 = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(button3Action:)];
    
    //UIBarButtonItem *button3 = [[UIBarButtonItem alloc]initWithImage:nil style:(UIBarButtonItemStylePlain) target:self action:@selector(button3Action:)];
    
    [buttons addObject:button1];
    [buttons addObject:button2];
    [buttons addObject:button3];
    
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
    
    self.navigationItem.rightBarButtonItem = myBtn;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //self.webView.delegate = self;
    
    [self requestData];
    
}

-(void)requestData{
    
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
        //NSLog(@"%@", string);
        
       [self.webView loadHTMLString:string baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        [self.view addSubview:self.webView];
    }];
    [dataTask resume];
    
    
    
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
//        UIColor *fontColor = [UIColor redColor];
//        NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",17.f,fontColor];
//        [_webView stringByEvaluatingJavaScriptFromString:jsString];
        
    } else if (_index == 3){
        _index = 0;
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '60%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    }
   
    
    
    
}
//收藏
-(void)button2Action:(id)sender{
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",19.f,[UIColor redColor]];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
}
//分享
-(void)button3Action:(id)sender{
  
    
}






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
