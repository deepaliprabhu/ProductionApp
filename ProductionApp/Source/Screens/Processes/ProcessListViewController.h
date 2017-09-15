//
//  ViewController.h
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "ActionPickerView.h"
#import "BaseViewController.h"
#import "Run.h"
#import "NIDropDown.h"

@interface ProcessListViewController : BaseViewController <SKSTableViewDelegate, ActionPickerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, NIDropDownDelegate> {
    IBOutlet UIView *_batchView;
    IBOutlet UIView *_tintView;
    IBOutlet UITextField *_okayTF;
    IBOutlet UITextField *_reworkTF;
    IBOutlet UITextField *_rejectTF;
    IBOutlet UITextField *_operatorTF;
    BOOL multiMode;
    NSMutableArray *statusActions;
    int timeLogged;
    int selectedProcessIndex;
    Run *run;
    
    UIAlertView *optionAlertView;
    NIDropDown *dropDown;
    NSString *selectedOperator;
    NSMutableArray *operatorArray;

}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)setMultiMode:(BOOL)value;
- (void)setRun:(Run*)run_;
@end
