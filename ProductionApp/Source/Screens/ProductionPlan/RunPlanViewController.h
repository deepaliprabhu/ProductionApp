//
//  RunPlanViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 25/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"
#import "DropDownListView.h"
#import "RunPlanViewCell.h"
#import "NIDropDown.h"
#import "CKCalendarView.h"
#import <Parse/Parse.h>

@interface RunPlanViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RunPlanCellDelegate, NIDropDownDelegate, CKCalendarDelegate> {
    IBOutlet UILabel *_runLabel;
    IBOutlet UILabel *_processLabel;
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_pickOperatorButton;
    IBOutlet UIButton *_pickDateButton;
    IBOutlet UITextField *_quantityTF;
    IBOutlet UIView *_editOperationView;
    IBOutlet UIView *_entryView;
    IBOutlet UIView *_tintView;
    IBOutlet UITextField *_okayTF;
    IBOutlet UITextField *_reworkTF;
    IBOutlet UITextField *_rejectTF;
    
    DropDownListView * dropDownList;
    NIDropDown *dropDown;
    Run *run;
    PFObject *savingObject;
    
    NSMutableArray *operationsArray;
    NSMutableArray *operatorArray;
    NSMutableArray *processesArray;
    int selectedListIndex;
}
- (void)setRun:(Run*)run_;
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end
