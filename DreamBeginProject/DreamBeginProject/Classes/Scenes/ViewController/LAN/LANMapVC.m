//
//  LANMapVC.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/16.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANMapVC.h"

#import <MAMapKit/MAMapKit.h>


@interface LANMapVC ()

{
    //定义全局地图
    MAMapView *_mapView;
    
}



@end

@implementation LANMapVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //设置apikey
    [MAMapServices sharedServices].apiKey = @"442edfd232f44f61f6b91d2bba557216";
    
    
    
    
    
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
