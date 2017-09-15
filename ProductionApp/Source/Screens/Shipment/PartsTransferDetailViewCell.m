//
//  PartsTransferDetailViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "PartsTransferDetailViewCell.h"

@implementation PartsTransferDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    if ([cellData[@"Part Number"] containsString:@"Select a Part"]) {
        _partNumberLabel.text = cellData[@"Product"];
    }
    else
        _partNumberLabel.text = cellData[@"Part Number"];
    _partDetailLabel.text = cellData[@"Details"];
    _quantityLabel.text = cellData[@"Qty"];
}

@end
