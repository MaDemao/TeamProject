//
//  MDMCollectCell.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/18.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMCollectCell.h"

@interface MDMCollectCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

@end

@implementation MDMCollectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCollect:(MDMCollect *)collect
{
    NSDate *date = collect.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm"];
    NSString *string = [formatter stringFromDate:date];
    self.timeText.text = string;
    self.titleText.text = collect.title;
}

@end
