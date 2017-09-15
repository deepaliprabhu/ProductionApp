//
//  ScheduleOperationsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 28/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVSelectorScrollView.h"
#import "DZNSegmentedControl.h"
#import "DropDownListView.h"
#import "ScheduleOperationsViewCell.h"
#import "NIDropDown.h"
#import <Parse/Parse.h>
#import "MVSelectorScrollView.h"

@interface ScheduleOperationsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MVSelectorScrollViewDelegate, ScheduleOperationsCellDelegate, NIDropDownDelegate> {
    IBOutlet UITableView *_tableView;
    
    IBOutlet UITextField *_processTF;
    IBOutlet UITextField *_quantityTF;
    IBOutlet UIButton *_pickOperatorButton;
    IBOutlet UIView *_editOperationView;
    IBOutlet UIView *_tintView;
    
    IBOutlet UIView *_entryView;
    IBOutlet UITextField *_okayTF;
    IBOutlet UITextField *_reworkTF;
    IBOutlet UITextField *_rejectTF;
    
    DZNSegmentedControl *control;
    DropDownListView * dropDownList;
    NIDropDown *dropDown;
    
    NSMutableArray *scheduleArray;
    NSMutableArray *operatorArray;
    NSMutableArray *operationsArray;
    NSMutableArray *runsArray;
    NSMutableArray *runIdsArray;
    NSMutableArray *monArray;
    NSMutableArray *tuesArray;
    NSMutableArray *wedArray;
    NSMutableArray *thuArray;
    NSMutableArray *friArray;
    NSMutableArray *satArray;
    NSMutableArray *processesArray;
    NSMutableArray *filteredRunsArray;
    NSMutableArray *unassignedOperations;
    
    PFObject *savingObject;
    
    int selectedDropDownTag;
    int selectedRunIndex;
    int selectedListIndex;
}
@property IBOutlet MVSelectorScrollView *scrollView;
@end
