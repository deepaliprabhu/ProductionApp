//
//  CommonProcessListViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/09/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "CommonProcessListViewCell.h"

@implementation CommonProcessListViewCell

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
    _processNameLabel.text = [NSString stringWithFormat:@"%@ - %@",cellData[@"processno"], cellData[@"processname"]];
    _stationLabel.text = cellData[@"stationid"];
}

- (IBAction)editPressed:(id)sender {
    
}

- (IBAction)deletePressed:(id)sender {
    [_delegate deleteProcessAtIndex:index];
}

@end
