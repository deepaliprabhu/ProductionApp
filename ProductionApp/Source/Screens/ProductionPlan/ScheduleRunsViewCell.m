//
//  ScheduleRunsViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ScheduleRunsViewCell.h"

@implementation ScheduleRunsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)runData index:(int)index_{
    index = index_;
    _runLabel.text = [NSString stringWithFormat:@"%@: %@",runData[@"RunId"], runData[@"ProductName"]];
    _countLabel.text = runData[@"Quantity"];
}

- (IBAction)deletePressed:(id)sender {
    [_delegate deleteRunAtIndex:index];
}

@end
