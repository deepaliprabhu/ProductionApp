//
//  ChecklistGenCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ChecklistGenCell.h"

@implementation ChecklistGenCell

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
    if (cellData[@"SensorId"]) {
        _sensorIdLabel.text = cellData[@"SensorId"];
    }
    else {
        _sensorIdLabel.text = cellData[@"MacAddress"];
    }
    if ([cellData[@"Status"] isEqualToString:@"REJECT"]) {
        [_statusButton setImage:[UIImage imageNamed:@"Cancel.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)editPressed {
    [_delegate editCellWithIndex:index];
}



@end
