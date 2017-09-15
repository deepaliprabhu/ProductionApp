//
//  ProcessFlowViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/08/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ProcessFlowViewCell.h"

@implementation ProcessFlowViewCell

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
    _processNameLabel.text = [NSString stringWithFormat:@"%d-%@", index_,cellData[@"processname"]];
    _stationLabel.text = cellData[@"stationid"];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [_delegate deleteProcessAtIndex:index];
}

@end
