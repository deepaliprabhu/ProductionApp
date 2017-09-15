//
//  DailyListViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyListCell.h"
#import "CKCalendarView.h"

@interface DailyListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DailyListCellDelegate, CKCalendarDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_tintedView;
    IBOutlet UIView *_cellDetailView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_processLabel;
    IBOutlet UILabel *_reworkLabel;
    IBOutlet UILabel *_rejectLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UIButton *_dateButton;
    NSMutableArray *parseRuns;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end
