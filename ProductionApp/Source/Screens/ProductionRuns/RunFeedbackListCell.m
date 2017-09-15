//
//  RunFeedbackListCell.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "RunFeedbackListCell.h"

@implementation RunFeedbackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _feedbackIdLabel.text = cellData[@"Feedback Id"];
    _statusLabel.text = cellData[@"Status"];
    _locationLabel.text = cellData[@"Location"];
    _receivedLabel.text = cellData[@"Received"];
    _createdByLabel.text = cellData[@"By"];
    _rmaIdLabel.text = cellData[@"RMA Id"];
    _categoryLabel.text = cellData[@"Category"];
    _issuesTextView.text = cellData[@"Issues"];
}

@end
