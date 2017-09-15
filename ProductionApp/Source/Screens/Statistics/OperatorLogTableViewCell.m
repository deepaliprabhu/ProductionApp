//
//  OperatorLogTableViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperatorLogTableViewCell.h"

@implementation OperatorLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _operatorLabel.text = cellData[@"Operator"];
    _qtyLabel.text = cellData[@"Quantity"];
    _operationsLabel.text = cellData[@"Operations"];
    _hoursLabel.text = [NSString stringWithFormat:@"%.1f",[cellData[@"Hours"] floatValue]/60];
    _pointsLabel.text = [NSString stringWithFormat:@"%d",[cellData[@"Hours"] intValue]*2];
}

@end
