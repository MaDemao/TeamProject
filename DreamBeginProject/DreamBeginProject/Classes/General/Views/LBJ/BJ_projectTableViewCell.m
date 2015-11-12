//
//  BJ_projectTableViewCell.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_projectTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation BJ_projectTableViewCell
- (void)setModel:(BJ_Homepage *)model{
    _name.text = model.title;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_small]];
    
    
    _project.layer.borderWidth=1;
    
    _project.layer.borderColor=[UIColor redColor].CGColor;


}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
