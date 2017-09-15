//
//  HistoryStatsViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryStatsViewCell : UITableViewCell {
    IBOutlet UILabel *_monthLabel;
    IBOutlet UILabel *_producedLabel;
    IBOutlet UILabel *_shippedLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
