//
//  RunPlanViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 25/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol RunPlanCellDelegate;
@interface RunPlanViewCell : UITableViewCell {
    IBOutlet UILabel *_stationIdLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_processLabel;
    IBOutlet UILabel *_operatorLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UIButton *_doneButton;
    
    BOOL done;
    int index;
}
__pd(RunPlanCellDelegate);
- (void)setCellData:(NSMutableDictionary *)cellData index:(int)index_;
@end

@protocol RunPlanCellDelegate <NSObject>
- (void) updateStatus:(BOOL)value forIndex:(int)index;
- (void) editOperationforIndex:(int)index;

@end
