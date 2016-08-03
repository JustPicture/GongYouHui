//
//  CALayer+borderColor.m
//  HMYD
//
//  Created by HMYD on 15/12/10.
//  Copyright © 2015年 HMYD. All rights reserved.
//

#import "CALayer+borderColor.h"

@implementation CALayer (borderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
