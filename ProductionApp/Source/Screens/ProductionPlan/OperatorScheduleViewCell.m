//
//  OperatorScheduleViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperatorScheduleViewCell.h"

@implementation OperatorScheduleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_{
    index = index_;
    _operationLabel.text = cellData[@"OperationName"];
    _quantityLabel.text = cellData[@"Quantity"];
    _stationIdLabel.text = cellData[@"StationId"];
    _runLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"RunId"], cellData[@"ProductName"]];
    _timeLabel.text = [NSString stringWithFormat:@"%.1f",[cellData[@"Time"] floatValue]/60];
    if ([cellData[@"Status"] isEqualToString:@"OPEN"]) {
        done = false;
        [_doneButton setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
    }
    else {
        done = true;
        [_doneButton setImage:[UIImage imageNamed:@"doneCheck.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)donePressed:(id)sender {
    if (done) {
        done = false;
        [_doneButton setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
        [_delegate updateStatus:false forIndex:index];
    }
    else {
        done = true;
        [_doneButton setImage:[UIImage imageNamed:@"doneCheck.png"] forState:UIControlStateNormal];
        [_delegate updateStatus:true forIndex:index];
    }
}

@end
