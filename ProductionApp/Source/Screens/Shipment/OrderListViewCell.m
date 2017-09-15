//
//  OrderListViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/05/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OrderListViewCell.h"

@implementation OrderListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _dateLabel.text = cellData[@"Date"];
    _locationLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"Order_id"],cellData[@"Account Name"]];
    _statusLabel.text = cellData[@"Status"];
}

@end
