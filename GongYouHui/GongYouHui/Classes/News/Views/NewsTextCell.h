//
//  NewsTextCell.h
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/11.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (strong, nonatomic) IBOutlet UIImageView *newsImageView;

@end
