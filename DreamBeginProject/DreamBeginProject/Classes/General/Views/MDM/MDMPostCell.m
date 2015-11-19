//
//  MDMPostCell.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMPostCell.h"
#import "MDMCommend.h"

@interface MDMPostCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *desText;

@end

@implementation MDMPostCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setPost:(MDMPost *)post
{
    self.headPic.layer.masksToBounds = YES;
    self.headPic.layer.cornerRadius = self.headPic.frame.size.height / 2.0;
    self.headPic.image = [UIImage imageNamed:@"iconfont-morentouxiang.png"];
    
    
    self.titleText.text = post.title;
    self.desText.text = post.des;
    MDMUserInfo *info = post.info;
    
    AVQuery *query = [MDMCommend query];
    [query whereKey:@"post" equalTo:post];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (number >= 1024) {
                int a = number / 1024.;
                self.commentCount.text = [NSString stringWithFormat:@"%.2fK", (double)a];
            }else{
                self.commentCount.text = [NSString stringWithFormat:@"%ld", number];
            }
        });
    }];
    
    [info fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        AVFile *avfile = info.image;
        NSData *data = [avfile getData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headPic.image = [UIImage imageWithData:data];
        });
    }];
}


@end
