//
//  LANDiseaseInfoCell.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LANGrugModel;
@class LANInfoModel;

@interface LANDiseaseInfoCell : UITableViewCell

@property(nonatomic,strong)LANGrugModel *drugModel;
@property(nonatomic,strong)LANInfoModel *infoModel;


@property (weak, nonatomic) IBOutlet UIImageView *LANDiseaseInfoImageView;

@property (weak, nonatomic) IBOutlet UILabel *LANDiseaseInfoTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *LANDiseaseInfoDetailLabel;







@end
