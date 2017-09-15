//
//  PartsTransferViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 19/05/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "CKCalendarView.h"
#import "DropDownListView.h"
#import "DZNSegmentedControl.h"

@interface PartsTransferViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, ConnectionProtocol,CKCalendarDelegate> {
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UIButton *_startDateButton;
    IBOutlet UIButton *_endDateButton;
    IBOutlet UIButton *_pickLocationButton;
    IBOutlet UIButton *_pickStatusButton;
    IBOutlet UITableView *_tableView;
    IBOutlet UITableView *_detailsTableView;
    IBOutlet UIView *_partDetailsView;
    IBOutlet UIView *_tintView;
    IBOutlet UIView *_tableContainerView;
    IBOutlet UIView *_customRangeView;
    
    DropDownListView * dropDownList;
    DZNSegmentedControl *periodControl;
    
    NSMutableArray *partsTransferArray;
    NSMutableArray *partDetailsArray;
    NSMutableArray *locationArray;
    NSMutableArray *statusArray;
    NSMutableArray *filteredArray;
    
    int selectedListIndex;
    int selectedDropDownTag;
    int selectedLocationIndex;
    int selectedStatusIndex;
    int selectedPeriodIndex;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end
