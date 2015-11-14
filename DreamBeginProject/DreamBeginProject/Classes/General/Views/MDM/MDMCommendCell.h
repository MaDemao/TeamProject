//
//  MDMCommendCell.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMCommend.h"

@interface MDMCommendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headPic;


@property (nonatomic, strong) MDMCommend *commend;

@end
