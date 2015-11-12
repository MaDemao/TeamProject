//
//  BJ_projectTableViewCell.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJ_Homepage.h"

@interface BJ_projectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property(nonatomic,strong)BJ_Homepage *model;
@property (weak, nonatomic) IBOutlet UILabel *project;
@end
