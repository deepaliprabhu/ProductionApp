//
//  DailyLogDashboardViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

@interface DailyLogDashboardViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CKCalendarDelegate> {
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_operationsLabel;
    IBOutlet UILabel *_hoursLabel;
    IBOutlet UIButton *_dateButton;
    IBOutlet UITableView *_tableView;

    NSMutableArray *logsArray;
    NSMutableArray *operationsArray;
    NSDate *selectedDate;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;

@end
