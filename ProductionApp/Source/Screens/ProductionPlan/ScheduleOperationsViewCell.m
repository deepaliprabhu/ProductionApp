//
//  ScheduleOperationsViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ScheduleOperationsViewCell.h"

@implementation ScheduleOperationsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(NSMutableDictionary*)cellData forRun:(NSMutableDictionary*)runData index:(int)index_ {
    index = index_;
    _stationIdLabel.text = cellData[@"StationId"];
    _runLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"RunId"],cellData[@"ProductName"]];
    _processLabel.text = cellData[@"OperationName"];
    _operatorLabel.text = cellData[@"OperatorName"];
    _quantityLabel.text = cellData[@"Quantity"];
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

- (IBAction)deletePressed:(id)sender {
    [_delegate deleteOperationAtIndex:index];
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
