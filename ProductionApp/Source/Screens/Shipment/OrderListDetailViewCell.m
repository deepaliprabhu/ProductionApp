//
//  PartsTransferDetailViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OrderListDetailViewCell.h"

@implementation OrderListDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _partNumberLabel.text = cellData[@"Product Id"];
    _partDetailLabel.text = cellData[@"Product"];
    _quantityLabel.text = cellData[@"Qty"];
}

@end
