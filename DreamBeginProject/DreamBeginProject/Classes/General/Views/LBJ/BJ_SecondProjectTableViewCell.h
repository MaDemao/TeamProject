//
//  BJ_SecondProjectTableViewCell.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJ_Project.h"
#import <UIImageView+WebCache.h>
@interface BJ_SecondProjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *smallTitle;
@property(nonatomic,strong)BJ_Project *model;
@end
