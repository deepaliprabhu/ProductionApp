//
//  DemandListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/05/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "DemandListCell.h"

@implementation DemandListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSDictionary*)cellData withTag:(int)tag_{
    tag = tag_;
    _expectedDateButton.tag = tag_;
    if (cellData[@"Product"]) {
        _titleLabel.text = cellData[@"Product"];
    }
    else {
        _titleLabel.text = cellData[@"ProductName"];
    }
    if (cellData[@"Runs"]) {
        [_runButton setTitle:cellData[@"Runs"] forState:UIControlStateNormal];
    }
    if (cellData[@"Shipping"]) {
        [_expectedDateButton setTitle:cellData[@"Shipping"] forState:UIControlStateNormal];
    }
}

- (IBAction)dateButtonPressed:(UIButton*)sender {
    [_delegate selectedExpectedShippingWithTag:tag];
}

- (void)setExpectedDate:(NSString*)dateString {
    [_expectedDateButton setTitle:dateString forState:UIControlStateNormal];
}

- (IBAction)runButtonPressed {
    if (![_runButton.titleLabel.text isEqualToString:@"--"]) {
        [_delegate selectedRunButtonWithTag:tag];
    }
}

@end
