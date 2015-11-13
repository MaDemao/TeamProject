//
//  BJ_SecondProjectTableViewCell.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_SecondProjectTableViewCell.h"

@implementation BJ_SecondProjectTableViewCell
- (void)setModel:(BJ_Project *)model{
    _title.text = model.name;
    _smallTitle.text = model.desc;
    [_imgView sd_setImageWithURL:[NSURL URLWithString: model.cover_small]];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
