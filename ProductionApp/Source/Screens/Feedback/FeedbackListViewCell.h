//
//  FeedbackListViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackListViewCell : UITableViewCell {
    IBOutlet UILabel *_feedbackIdLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_issuesLabel;
}

- (void)setCellData:(NSMutableDictionary*)cellData;
@end
