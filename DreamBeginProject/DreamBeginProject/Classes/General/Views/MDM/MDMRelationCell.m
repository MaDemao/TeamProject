//
//  MDMRelationCell.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMRelationCell.h"

@interface MDMRelationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *personText;

@end

@implementation MDMRelationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(MDMUserInfo *)info
{
    self.headPic.image = [UIImage imageNamed:@"iconfont-morentouxiang.png"];
    self.headPic.layer.masksToBounds = YES;
    self.headPic.layer.cornerRadius = self.headPic.frame.size.height / 2.;
    
    self.nameText.text = info.name;
    self.personText.text = info.personality;
    AVFile *avfile = info.image;
    NSData *data = [avfile getData];
    self.headPic.image = [UIImage imageWithData:data];
}

@end
