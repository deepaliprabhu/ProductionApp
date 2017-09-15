//
//  OperatorScheduleViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import "OperatorScheduleViewCell.h"
#import <Parse/Parse.h>
#import "MVSelectorScrollView.h"

@interface OperatorScheduleViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, OperatorScheduleCellDelegate, MVSelectorScrollViewDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_entryView;
    IBOutlet UITextField *_okayTF;
    IBOutlet UITextField *_reworkTF;
    IBOutlet UITextField *_rejectTF;
    
    DZNSegmentedControl *control;
    
    NSMutableArray *operatorArray;
    NSMutableArray *scheduleArray;
    NSMutableArray *operationsArray;
    NSMutableArray *filteredArray;
    
    int operatorIndex;
    PFObject *savingObject;
    NSString *startDateString;
    NSString *endDateString;
}
@property IBOutlet MVSelectorScrollView *scrollView;

- (void)setOperatorIndex:(int)index;
@end
