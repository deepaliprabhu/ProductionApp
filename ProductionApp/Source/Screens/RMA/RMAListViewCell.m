//
//  RMAListViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 16/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "RMAListViewCell.h"

@implementation RMAListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _rmaIdLabel.text = cellData[@"Rma Id"];
    _statusLabel.text = cellData[@"Status"];
    _dateLabel.text = cellData[@"Date"];
    _productLabel.text = cellData[@"Product"];
    _locationLabel.text = cellData[@"Location"];
}

@end
