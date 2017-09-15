//
//  RunFeedbackListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunFeedbackListCell : UITableViewCell {
    IBOutlet UILabel *_feedbackIdLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_categoryLabel;
    IBOutlet UILabel *_createdByLabel;
    IBOutlet UILabel *_receivedLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UITextView *_issuesTextView;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
