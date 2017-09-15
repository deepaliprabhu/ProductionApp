//
//  ScheduleOperationsViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"
#import "Defines.h"

@protocol ScheduleOperationsCellDelegate;
@interface ScheduleOperationsViewCell : UITableViewCell {
    IBOutlet UILabel *_stationIdLabel;
    IBOutlet UILabel *_runLabel;
    IBOutlet UILabel *_processLabel;
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UIButton *_doneButton;
    
    BOOL done;
    int index;
}
__pd(ScheduleOperationsCellDelegate);
-(void)setCellData:(NSMutableDictionary*)cellData forRun:(NSMutableDictionary*)runData index:(int)index_;
@end

@protocol ScheduleOperationsCellDelegate <NSObject>
- (void) deleteOperationAtIndex:(int)index;
- (void) updateStatus:(BOOL)value forIndex:(int)index;
@end
