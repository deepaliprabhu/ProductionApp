//
//  DailyStatsViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/08/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "DailyStatsViewCell.h"

@implementation DailyStatsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setCellData:(Station*)station {
    _indexLabel.text = [NSString stringWithFormat:@"%d",[station getStationId]];
    _titleLabel.text = [station getStationName];
    _qtyLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[station getProcessEntries].count];
    _timeLabel.text = [NSString stringWithFormat:@"%.1f",(float)[station getTime]/60];
}

@end
