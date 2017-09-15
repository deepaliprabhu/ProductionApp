//
//  RunPlanViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 25/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "RunPlanViewCell.h"

@implementation RunPlanViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary *)cellData index:(int)index_{
    index = index_;
    _stationIdLabel.text = cellData[@"StationId"];
    _processLabel.text = cellData[@"OperationName"];
    _operatorLabel.text = cellData[@"OperatorName"];
    _quantityLabel.text = cellData[@"Quantity"];
    _dateLabel.text = cellData[@"DateAssigned"];
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
    }
    else {
        done = true;
        [_doneButton setImage:[UIImage imageNamed:@"doneCheck.png"] forState:UIControlStateNormal];
    }
    [_delegate updateStatus:done forIndex:index];
}

- (IBAction)editPressed:(id)sender {
    [_delegate editOperationforIndex:index];
}

@end
