//
//  OperationsLogTableViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperationsLogTableViewCell.h"

@implementation OperationsLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _operationLabel.text = cellData[@"Operation"];
    _qtyLabel.text = cellData[@"Quantity"];
    _operatorLabel.text = cellData[@"Operator"];
    _hoursLabel.text = [NSString stringWithFormat:@"%.1f",[cellData[@"Hours"] floatValue]/60];
}

@end
