//
//  MDMMyFansTVC.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMFans.h"
#import "MDMUserInfo.h"

@interface MDMMyFansTVC : UITableViewController

@property (nonatomic, assign) NSInteger pushType;

@property (nonatomic, strong) MDMUserInfo *info;

@end
