//
//  MDMMyCommendCell.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMMyCommendCell.h"
#import "MDMUserInfo.h"

@interface MDMMyCommendCell ()
@property (weak, nonatomic) IBOutlet UILabel *postTitleText;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UILabel *desText;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;

@end

@implementation MDMMyCommendCell

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
    self.headPic.layer.cornerRadius = self.headPic.frame.size.width / 2;
    
    MDMPost *post = commend.post;
    [post fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        self.postTitleText.text = post.title;
        
        MDMUserInfo *info = post.info;
        [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            AVFile *avfile = info.image;
            NSData *data = [avfile getData];
            
            self.headPic.image = [UIImage imageWithData:data];
        }];
    }];
    
    self.dateText.text = [commend.date substringToIndex:16];
    self.desText.text = commend.des;
}

@end
