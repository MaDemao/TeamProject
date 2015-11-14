//
//  MDMUserPostCell.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserPostCell.h"

@interface MDMUserPostCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

@end

@implementation MDMUserPostCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(MDMPost *)post
{
    self.timeText.text = post.date;
    self.titleText.text = post.title;
}

@end
