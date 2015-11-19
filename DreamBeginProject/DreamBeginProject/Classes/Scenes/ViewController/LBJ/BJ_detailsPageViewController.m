//
//  BJ_detailsPageViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_detailsPageViewController.h"
#import "Networking.h"
#import "MDMUserHelper.h"
#import "MDMLoginVC.h"

#define kURL(i) @"http://dxy.com/app/i/columns/article/single?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&id=%ld&mc=8c86141d0947ea82472ff29157b5783b8a996503&vc=4.0.8",i

#import <AVUser.h>
#import "UMSocial.h"
@interface BJ_detailsPageViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, strong)NSString *string;

@property (nonatomic, assign)NSInteger index;
@end

@implementation BJ_detailsPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawWenView];
     [self loadData];

    _index = 2;
        self.view.backgroundColor = [UIColor whiteColor];
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.navigationController.navigationBar.translucent = NO;
    UIImage *image = [UIImage imageNamed:@"fenxiang"];
    UIImage *image1 = [UIImage imageNamed:@"ziti"];
    UIImage *image2 = [UIImage imageNamed:@"shoucang"];
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
//    _webView.scalesPageToFit =YES;
 
    _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _webView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//这里webView的frame时充满屏幕的
}

 
//取html标签
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.x > 0) {
        scrollView.contentOffset = CGPointMake(0, point.y);//这里不要设置为CGPointMake(0, point.y)，这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
    }
}
 //取html标签(分享的时候把尖括号全部去掉只剩文字)
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
   
    if (st.length > 130) {
        st = [st substringToIndex:129];
        st = [st stringByAppendingString:@"..."];
        
    }
    
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5646898a67e58e8c57002553" shareText:st shareImage:[UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToDouban,UMShareToEmail, nil] delegate:nil];
        
  
    
    
    
}
- (void)rightTwo{
    
    _index++;
    if (_index == 1) {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    }else if (_index == 2){
        
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        //        UIColor *fontColor = [UIColor redColor];
        //        NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",17.f,fontColor];
        //        [_webView stringByEvaluatingJavaScriptFromString:jsString];
        
    } else if (_index == 3){
        _index = 0;
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        
    }
    
    
}
- (void)rightThree{
    
    if ([MDMUserHelper sharedMDMUserHelper].currentUser) {
        
        if ([MDMUserHelper isCollectOfBJ:self.ID]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经收藏" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0];
        }else{
            if (self.titleStr) {
                [MDMUserHelper collectOfBJ:self.ID title:self.titleStr];
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

- (void)drawWenView{
    

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height - 64)];
    _webView.backgroundColor = [UIColor whiteColor];
//    _webView.scalesPageToFit =YES;
    _webView.delegate =self;
//    _webView.alwaysBounceVertical = NO;
    _webView.scrollView.alwaysBounceVertical = YES;
    
    
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
        self.titleStr = secondStr;
        //通过right分割成多个,存到数组里
        NSArray *arrayStr = [str componentsSeparatedByString:@"right"];
      
        str = arrayStr[0];
       
       
        //去webView里面的链接的
        NSArray *arrayStrTwo = [str componentsSeparatedByString:@"href"];

        NSString *strTwo = arrayStrTwo[0];
        NSArray *arrayStrThree = [str componentsSeparatedByString:@"_blank"];
        
        NSString *strThree = arrayStrThree.lastObject;
        //判断html里面是否含有href 有的话拼接 没有直接显示
        if([str rangeOfString:@"href"].location !=NSNotFound)//_roaldSearchText
        {
            str = [strTwo stringByAppendingString:[NSString stringWithFormat:@"%@",strThree]];
        }
        else
        {
          
        }
        
        //拼接字符串 h1字体最大
          str = [@"<h1>" stringByAppendingString:[NSString stringWithFormat:@"%@</h1>%@",secondStr,str]];
        
        //修改图片尺寸适应屏幕
        NSInteger weight = self.view.frame.size.width - 10;
     NSString *str2 = [NSString stringWithFormat:@"<head><style>img{width:%ldpx !important;}</style></head>",(long)weight];
        str = [str2 stringByAppendingString:str];
        self.string = str;
        
        
       
          str = [NSString stringWithFormat:@"<body>%@</body>",str];
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
//    

    

    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    
    
    // 禁用用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    
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
