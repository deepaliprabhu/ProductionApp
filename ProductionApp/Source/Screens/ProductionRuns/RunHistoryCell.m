//
//  RunHistoryCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "RunHistoryCell.h"

@implementation RunHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _dateLabel.text = cellData[@"Date"];
    NSString *activityString = @"";
    if ((![cellData[@"Quantity"] isEqualToString:@""])&&(![cellData[@"Quantity"] isEqualToString:@"0"])) {
        activityString = [activityString stringByAppendingString:[NSString stringWithFormat:@"Moved %@ units to %@.\n", cellData[@"Quantity"], cellData[@"ProcessName"]]];
    }
    if ((![cellData[@"Shipped"] isEqualToString:@""])&&(![cellData[@"Shipped"] isEqualToString:@"0"])) {
        activityString = [activityString stringByAppendingString:[NSString stringWithFormat:@"Moved %@ units to %@.\n", cellData[@"Shipped"], @"Shipped"]];
    }
    if ((![cellData[@"Reworks"] isEqualToString:@""])&&(![cellData[@"Reworks"] isEqualToString:@"0"])) {
        activityString = [activityString stringByAppendingString:[NSString stringWithFormat:@"Moved %@ units to %@.\n", cellData[@"Reworks"], cellData[@"ProcessName"]]];
    }
    if ((![cellData[@"Rejects"] isEqualToString:@""])&&(![cellData[@"Rejects"] isEqualToString:@"0"])) {
        activityString = [activityString stringByAppendingString:[NSString stringWithFormat:@"Moved %@ units to %@.\n", cellData[@"Rejects"], @"Rejects"]];
    }

    _activityTextView.text = activityString;
}

@end
