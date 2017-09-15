//
//  ProcessListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "ProcessListCell.h"

@implementation ProcessListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProcessData:(Process*)process {
    switch ([process getProcessStatus]) {
        case 0:
        _statusView.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:191.0f/255.0f blue:59.0f/255.0f alpha:0.7];
            break;
        case 1:
            _statusView.backgroundColor = [UIColor colorWithRed:0.145 green:0.737 blue:0.490 alpha:1.000];
            break;
        case 2:
            _statusView.backgroundColor = [UIColor colorWithRed:189.0f/255 green:195.0f/255 blue:199.0f/255 alpha:1];
            break;
        default:
            break;
    }

}
@end
