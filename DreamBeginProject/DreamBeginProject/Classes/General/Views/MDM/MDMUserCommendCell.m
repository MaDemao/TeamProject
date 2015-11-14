//
//  MDMUserCommendCell.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserCommendCell.h"

@interface MDMUserCommendCell ()
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

@end

@implementation MDMUserCommendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommend:(MDMCommend *)commend
{
    self.commentText.text = commend.des;
    MDMPost *post = commend.post;
    [post fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        self.titleText.text = post.title;
    }];
}

@end
