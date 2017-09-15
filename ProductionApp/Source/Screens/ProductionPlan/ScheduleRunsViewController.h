//
//  ScheduleRunsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import "DropDownListView.h"

@interface ScheduleRunsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    
    DZNSegmentedControl *control;
    DropDownListView * dropDownList;
    
    NSMutableArray *scheduleArray;
    NSMutableArray *runsArray;
    NSMutableArray *runIdsArray;
    NSMutableArray *filteredRunsArray;
    NSMutableArray *thisWeekRunsArray;
    NSMutableArray *nextWeekRunsArray;
}

@end
