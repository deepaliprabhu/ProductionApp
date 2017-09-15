//
//  HistoryStatsViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "HistoryStatsViewCell.h"

@implementation HistoryStatsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _monthLabel.text = cellData[@"Month"];
    _producedLabel.text = cellData[@"Produced"];
    _shippedLabel.text = cellData[@"Shipped"];
}

@end
