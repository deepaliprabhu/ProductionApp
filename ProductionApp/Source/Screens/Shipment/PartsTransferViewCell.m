//
//  PartsTransferViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "PartsTransferViewCell.h"

@implementation PartsTransferViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _dateLabel.text = cellData[@"Date"];
    _locationLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"Transfer_id"],cellData[@"Location 1"]];
    _locationToLabel.text = cellData[@"Location 2"];
    _statusLabel.text = cellData[@"Status"];
}

@end
