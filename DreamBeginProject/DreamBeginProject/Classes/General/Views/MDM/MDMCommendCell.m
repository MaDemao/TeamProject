//
//  MDMCommendCell.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMCommendCell.h"
#import "MDMUserInfo.h"

@interface MDMCommendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UILabel *desText;

@end

@implementation MDMCommendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommend:(MDMCommend *)commend
{
    self.headPic.image = [UIImage imageNamed:@"iconfont-morentouxiang.png"];
    self.headPic.layer.masksToBounds = YES;
    self.headPic.layer.cornerRadius = self.headPic.frame.size.height / 2;
    MDMUserInfo *info = commend.info;
    [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        self.nameText.text = info.name;
        AVFile *avfile = info.image;
        NSData *data = [avfile getData];
        self.headPic.image = [UIImage imageWithData:data];
    }];
    self.dateText.text = commend.date;
    self.desText.text = commend.des;
}

@end
