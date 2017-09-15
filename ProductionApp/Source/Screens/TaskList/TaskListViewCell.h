//
//  TaskListViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol TaskListCellDelegate;
@interface TaskListViewCell : UITableViewCell {
    IBOutlet UILabel *_assignedToLabel;
    IBOutlet UILabel *_assignedByLabel;
    IBOutlet UILabel *_dueLabel;
    IBOutlet UIButton *_statusButton;
    IBOutlet UITextView *_textView;
    
    int index;
    BOOL closed;
}
__pd(TaskListCellDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_;

@end

@protocol TaskListCellDelegate <NSObject>
- (void) updateStatus:(BOOL)value forIndex:(int)index;
- (void) deleteTaskAtIndex:(int)index;
@end
