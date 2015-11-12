//
//  MDMLoginVC.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^settingBlock)(BOOL,BOOL);
@interface MDMLoginVC : UIViewController
@property (nonatomic, strong) settingBlock theBlock;
@end
