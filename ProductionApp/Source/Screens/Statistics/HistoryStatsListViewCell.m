//
//  HistoryStatsListViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "HistoryStatsListViewCell.h"

@implementation HistoryStatsListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)statsData {
    NSString *dateString = [statsData[@"Date"] stringByReplacingOccurrencesOfString:@" " withString:@"/"];
    _dateLabel.text = dateString;
    _countLabel.text = statsData[@"TotalQuantity"];
    _operationsLabel.text = statsData[@"TotalOperations"];
    _timeLabel.text = [NSString stringWithFormat:@"%.1f",[statsData[@"TotalTime"] floatValue]/60];
}

@end
