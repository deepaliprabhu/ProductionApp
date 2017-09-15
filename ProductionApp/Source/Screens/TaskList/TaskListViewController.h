//
//  TaskListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CKCalendarView.h"
#import "TaskListViewCell.h"

@interface TaskListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NIDropDownDelegate, CKCalendarDelegate, TaskListCellDelegate> {
    IBOutlet UIButton *_assignedByButton;
    IBOutlet UIButton *_assignedToButton;
    IBOutlet UIButton *_dueDateButton;
    IBOutlet UIView *_addTaskView;
    IBOutlet UITextView *_textView;
    IBOutlet UITableView *_tableView;
    
    NIDropDown *dropDown;
    
    NSMutableArray *namesArray;
    NSMutableArray *tasksArray;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;

- (void)setTasks:(NSMutableArray*)tasksArray_;

@end
