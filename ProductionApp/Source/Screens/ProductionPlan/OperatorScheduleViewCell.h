//
//  OperatorScheduleViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol OperatorScheduleCellDelegate;
@interface OperatorScheduleViewCell : UITableViewCell {
    IBOutlet UILabel *_runLabel;
    IBOutlet UILabel *_operationLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_stationIdLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UIButton *_doneButton;
    BOOL done;
    int index;
}
__pd(OperatorScheduleCellDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_;

@end

@protocol OperatorScheduleCellDelegate <NSObject>
- (void) updateStatus:(BOOL)value forIndex:(int)index;
@end
