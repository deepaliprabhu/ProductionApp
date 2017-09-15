//
//  ScheduleRunsViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"
#import "Defines.h"

@protocol ScheduleRunsCellDelegate;
@interface ScheduleRunsViewCell : UITableViewCell<ScheduleRunsCellDelegate> {
    IBOutlet UILabel *_runLabel;
    IBOutlet UILabel *_countLabel;
    
    int index;
}
__pd(ScheduleRunsCellDelegate);
- (void)setCellData:(NSMutableDictionary*)run index:(int)index_;
@end

@protocol ScheduleRunsCellDelegate <NSObject>
- (void) deleteRunAtIndex:(int)index;
@end
