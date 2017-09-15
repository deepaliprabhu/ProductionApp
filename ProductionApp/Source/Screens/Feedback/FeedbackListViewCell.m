//
//  FeedbackListViewCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "FeedbackListViewCell.h"

@implementation FeedbackListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _feedbackIdLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"Feedback Id"],cellData[@"Product Name"]];
    _issuesLabel.text = cellData[@"Subject"];
    _statusLabel.text = cellData[@"Status"];
}
@end
