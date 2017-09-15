//
//  DefectsListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 21/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "DefectsListCell.h"

@implementation DefectsListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDefect:(Defect*)defect_ {
    _textView.text = [defect_ getText];
    switch ([defect_ getDefectType]) {
        case 0:
            [_typeImageView setImage:[UIImage imageNamed:@"electronics_orange.png"]];
            break;
        case 1:
            [_typeImageView setImage:[UIImage imageNamed:@"mechanical_orange.png"]];
            break;
        case 2:
            [_typeImageView setImage:[UIImage imageNamed:@"machine_orange.png"]];
            break;
        case 3:
            [_typeImageView setImage:[UIImage imageNamed:@"firmware_orange.png"]];
            break;
        default:
            break;
    }
}

@end
