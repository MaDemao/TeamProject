//
//  LANDrugVC.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANDrugVC.h"
//#import "LANHelper1.h"
#import "LANGrugModel.h"
@interface LANDrugVC ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;


@end

@implementation LANDrugVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //self.webView.delegate = self;
    //self.webView.backgroundColor = [UIColor redColor];
    //
    self.webView.scalesPageToFit =YES;
    [self requestData];
    
}

-(void)requestData{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://phone.lkhealth.net/ydzx/business/apppage/druginfo.html?&drugid=%@",self.drugModel.drugId];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];

//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
//        // NSLog(@"=============%@",rootDict);
//
//        NSDictionary *dict = rootDict[@"data"][@"drugInfo"];
//        
//        NSString *string = dict[@"indication"];
//        
//        //[self.webView loadHTMLString:string baseURL:nil];
//        //[self.view addSubview:self.webView];
//
//    }];
//    
//    [dataTask resume];
    
    
    
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
