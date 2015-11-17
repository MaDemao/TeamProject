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

#import <AVUser.h>
#import "UMSocial.h"
@interface BJ_detailsPageViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@property (nonatomic, strong)NSString *string;

@property (nonatomic, assign)NSInteger index;
@end

@implementation BJ_detailsPageViewController


- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
        self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawWenView];
     [self loadData];

    
    _index = 2;
        self.view.backgroundColor = [UIColor whiteColor];
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.navigationController.navigationBar.translucent = NO;
    UIImage *image = [UIImage imageNamed:@"7.jpg"];
    UIImage *image1 = [UIImage imageNamed:@"5.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"3.jpg"];
     image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //分享
    UIBarButtonItem *rightOne = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightOne)];
   
    //改变字体
    UIBarButtonItem *rightTwo = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(rightTwo)];
     //收藏
    UIBarButtonItem *rightThree = [[UIBarButtonItem alloc]initWithImage:image2 style:UIBarButtonItemStylePlain target:self action:@selector(rightThree)];
    self.navigationItem.rightBarButtonItems = @[rightOne,rightThree,rightTwo];
    _webView.scalesPageToFit =YES;
    
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
- (void)rightOne{
    NSString *st = [self filterHTML:self.string];
   
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5646898a67e58e8c57002553" shareText:st shareImage:[UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToDouban,UMShareToEmail, nil] delegate:nil];
        
  
    
    
    
}
- (void)rightTwo{
    
    _index++;
    if (_index == 1) {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    }else if (_index == 2){
        
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        //        UIColor *fontColor = [UIColor redColor];
        //        NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",17.f,fontColor];
        //        [_webView stringByEvaluatingJavaScriptFromString:jsString];
        
    } else if (_index == 3){
        _index = 0;
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    }
    
    
}
- (void)rightThree{
    
    
    
    
}
- (void)drawWenView{
    

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 10, [UIScreen mainScreen].bounds.size.height - 64)];
    _webView.backgroundColor = [UIColor whiteColor];
//    _webView.scalesPageToFit =YES;
    _webView.delegate =self;
    
    
}

- (void)loadData{
    NSString *url = [NSString stringWithFormat:kURL(_ID)];
    NSLog(@"%ld",_ID);
    [[Networking shareNetworking]networkingGetWithURL:url Block:^(id object) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *secondDict = dict[@"data"];
        NSArray *array = secondDict[@"items"];
        NSDictionary *dict1 = [array firstObject];
            NSString *str = dict1[@"content"];
            NSString *secondStr = dict1[@"title"];
        
          str = [@"<h1>" stringByAppendingString:[NSString stringWithFormat:@"%@</h1>%@",secondStr,str]];
        self.string = str;
//          str = [NSString stringWithFormat:@"<body>%@</body>",str];
            [_webView loadHTMLString:str baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        
        
            
       
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_webView];
    });
   

    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //拦截网页图片  并修改图片大小
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function ResizeImages() { "
//     "var myimg,oldwidth;"
//     "var maxwidth=380;" //缩放系数
//     "for(i=0;i <document.images.length;i++){"
//     "myimg = document.images[i];"
//     "if(myimg.width > maxwidth){"
//     "oldwidth = myimg.width;"
//     "myimg.width = maxwidth;"
//     "myimg.height = myimg.height * (maxwidth/oldwidth);"
//     "}"
//     "}"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script);"];
//    
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
   
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
