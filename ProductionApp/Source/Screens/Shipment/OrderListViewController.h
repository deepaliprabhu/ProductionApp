//
//  PartsTransferViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "CKCalendarView.h"
#import "DropDownListView.h"


typedef enum {
    LISTTYPESTATUS = 1,
    LISTTYPEPRODUCT = 2
}ListType;

@interface OrderListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, ConnectionProtocol,CKCalendarDelegate> {
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UILabel *_accountIdLabel;
    IBOutlet UILabel *_orderIdLabel;
    IBOutlet UILabel *_countLabel;
    IBOutlet UILabel *_customerLabel;
    IBOutlet UIButton *_startDateButton;
    IBOutlet UIButton *_endDateButton;
    IBOutlet UIButton *_pickButton;
    IBOutlet UITableView *_tableView;
    IBOutlet UITableView *_detailsTableView;
    IBOutlet UIView *_partDetailsView;
    IBOutlet UIView *_tintView;
    
    NSMutableArray *ordersArray;
    NSMutableArray *statusArray;
    NSMutableArray *productArray;
    NSMutableArray *partDetailsArray;
    NSMutableArray *dropdownArray;
    NSMutableArray *filteredArray;
    DropDownListView * dropDownList;
    BOOL filtered;
    ListType listType;
    int selectedIndex;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
- (void)setListType:(ListType)listType_;
- (void)setSelectedIndex:(int)index;
- (void)setOrdersArray:(NSMutableArray*)ordersArray_;
@end
