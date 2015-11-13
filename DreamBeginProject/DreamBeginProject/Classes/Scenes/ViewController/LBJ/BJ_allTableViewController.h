//
//  BJ_allTableViewController.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BJ_allTableViewController : UITableViewController
- (instancetype)initWithUrl:(NSString *)url;
@property(nonatomic,strong)NSString *url;
@end
