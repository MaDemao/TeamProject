//
//  BJ_HomeTableViewCell.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_HomeTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation BJ_HomeTableViewCell
- (void)setModel:(BJ_Homepage *)model{
    _name.text = model.title;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_small]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
