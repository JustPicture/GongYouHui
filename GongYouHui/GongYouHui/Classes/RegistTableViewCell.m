//
//  RegistTableViewCell.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/13.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "RegistTableViewCell.h"

@implementation RegistTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.labelName.numberOfLines = 0;
    self.placeholder.borderStyle = UITextBorderStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
