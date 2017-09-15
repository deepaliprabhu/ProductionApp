//
//  OperatorDashboardViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "OperatorDashboardViewCell.h"

@implementation OperatorDashboardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _operatorLabel.text = cellData[@"Operator"];
    _quantityLabel.text = cellData[@"Quantity"];
    _timeLabel.text = [NSString stringWithFormat:@"%.1f",[cellData[@"Time"] floatValue]/60];
}

@end
