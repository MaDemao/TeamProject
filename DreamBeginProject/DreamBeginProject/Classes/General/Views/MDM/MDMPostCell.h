//
//  MDMPostCell.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMPost.h"
@interface MDMPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headPic;


@property (nonatomic, strong) MDMPost *post;
@end
