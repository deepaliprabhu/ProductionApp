//
//  HistoryStatsListViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryStatsListViewCell : UITableViewCell {
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_countLabel;
    IBOutlet UILabel *_operationsLabel;
    IBOutlet UILabel *_timeLabel;
}

- (void)setCellData:(NSMutableDictionary*)statsData;
@end
