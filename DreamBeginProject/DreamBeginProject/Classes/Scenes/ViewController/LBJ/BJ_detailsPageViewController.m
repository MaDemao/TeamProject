//
//  BJ_detailsPageViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_detailsPageViewController.h"
#import "Networking.h"
#define kURL(i) @"http://dxy.com/app/i/columns/article/single?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&id=%ld&mc=8c86141d0947ea82472ff29157b5783b8a996503&vc=4.0.8",i
@interface BJ_detailsPageViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation BJ_detailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawWenView];
     [self loadData];
}
- (void)drawWenView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 10, [UIScreen mainScreen].bounds.size.height)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit =YES;
    _webView.delegate =self;
     [self.view addSubview:_webView];
    
}
- (void)loadData{
    NSString *url = [NSString stringWithFormat:kURL(_ID)];
    [[Networking shareNetworking]networkingGetWithURL:url Block:^(id object) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *secondDict = dict[@"data"];
        NSArray *array = secondDict[@"items"];
        NSDictionary *dict1 = [array firstObject];
            NSString *str = dict1[@"content"];
            NSString *secondStr = dict1[@"title"];
        
          str = [@"<h1>" stringByAppendingString:[NSString stringWithFormat:@"%@</h1>%@",secondStr,str]];
        
          str = [NSString stringWithFormat:@"<body>%@</body>",str];
            [_webView loadHTMLString:str baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        
        
            
       
    }];
    
   

    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"];
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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
