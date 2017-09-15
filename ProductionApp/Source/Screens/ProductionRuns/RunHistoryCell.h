//
//  RunHistoryCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunHistoryCell : UITableViewCell {
    IBOutlet UILabel *_dateLabel;
    IBOutlet UITextView *_activityTextView;
}

- (void)setCellData:(NSMutableDictionary*)cellData;
@end
