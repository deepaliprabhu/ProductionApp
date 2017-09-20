//
//  CommonProcessListViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/09/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol CommonProcessListViewCellDelegate;
@interface CommonProcessListViewCell : UITableViewCell {
    IBOutlet UILabel *_processNameLabel;
    IBOutlet UILabel *_stationLabel;
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_timeLabel;
    
    int index;
}
__pd(CommonProcessListViewCellDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_;
@end

@protocol CommonProcessListViewCellDelegate <NSObject>
- (void) deleteProcessAtIndex:(int)index;
@end
