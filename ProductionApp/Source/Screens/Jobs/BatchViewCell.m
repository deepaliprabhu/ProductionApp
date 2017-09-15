//
//  BatchViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 01/09/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "BatchViewCell.h"

@implementation BatchViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.borderColor = [UIColor colorWithRed:200.0f/255 green:200.0f/255 blue:200.0f/255 alpha:0.7].CGColor;
    self.layer.borderWidth = 1;
}

@end
