//
//  DemandListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemandListCell.h"
#import "DZNSegmentedControl.h"
#import "ConnectionManager.h"
#import "ActionPickerView.h"
#import "CKCalendarView.h"
#import "MIBadgeButton.h"
#import "NIDropDown.h"


@interface DemandListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ConnectionProtocol, ActionPickerDelegate, DemandListCellDelegate, NIDropDownDelegate > {
    DZNSegmentedControl *control;
    NSMutableArray *productsArray;
    NSArray *quantityArray;
    IBOutlet UITableView *_tableView;
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_asapCountLabel;
    IBOutlet UILabel *_asapDateLabel;
    IBOutlet UILabel *_masonCountLabel;
    IBOutlet UILabel *_masonDateLabel;
    IBOutlet UILabel *_longCountLabel;
    IBOutlet UILabel *_longDateLabel;
    IBOutlet UILabel *_shippingEntryTitleLabel;
    IBOutlet UIButton *_pickRunButton;
    IBOutlet UIButton *_pickShippingButton;
    IBOutlet UITextView *_commentsTextView;
    IBOutlet UITextField *_countTextField;
    
    IBOutlet UIView *_detailView;
    IBOutlet UIView *_tintedView;
    IBOutlet UIView *_shippingEntryView;
    IBOutlet MIBadgeButton *_taskButton;
    NIDropDown *dropDown;

    
    NSMutableArray *dateActions;
    NSMutableArray *filteredArray;
    NSMutableArray *runsArray;
    NSMutableArray *tasksArray;
    
    BOOL filtered;
    int selectedIndex;
    int selectedTag;
    int selectedActionTag;
    int dropDownTag;
    int selectedRunId;
    NSString *selectedShipping;
    NSMutableDictionary *selectedDemand;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
- (void) parseJsonResponse:(NSData*)jsonData;
@end
