//
//  ShipmentListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "ShipmentListCell.h"

@implementation ShipmentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(NSMutableDictionary*)cellData {
    _dateLabel.text = cellData[@"Date"];
    _locationLabel.text = cellData[@"Location"];
    _qtyLabel.text = cellData[@"TransferId"];
}

@end
